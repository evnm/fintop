require 'json'
require 'net/http'

module Fintop
  # Contains functions that gather Finagle application metrics.
  module Metrics
    extend self

    # Query a Finagle server's stats endpoint to produce a hash of metrics.
    #
    # @param finp [FinagleProcess]
    def apply(finp)
      case finp.stats_lib
      when :metrics_tm
        scrape_metrics_tm(finp.admin_port)
      when :ostrich
        scrape_ostrich(finp.admin_port)
      else
        raise ArgumentError.new('invalid `FinagleProcess.stats_lib` symbol')
      end
    end

    private

    # Fetch metrics from a MetricsTM stats endpoint (/admin/metrics.json).
    # Returns a nested hash keyed by the metric prefix.
    # i.e. { jvm => { uptime => 18251.0, fd_count = 203.0, ... }, ... }
    #
    # @param admin_port [Fixnum]
    def scrape_metrics_tm(admin_port)
      json_str = Net::HTTP.get(
        URI.parse("http://localhost:#{admin_port}/admin/metrics.json")
      )

      result = {}
      JSON.parse(json_str).each { |k, v|
        prefix, rest = k.split('/', 2)
        (result[prefix] ||= {})[rest] = v
      }
      result
    end

    # Fetch metrics from an Ostrich stats endpoint (/stats.json).
    # Returns a nested hash keyed by the metric prefix.
    # i.e. { jvm => { uptime => 18251.0, fd_count = 203.0, ... }, ... }
    #
    # @param admin_port [Fixnum]
    def scrape_ostrich(admin_port)
      json = JSON.parse(
        Net::HTTP.get(URI.parse("http://localhost:#{admin_port}/stats.json"))
      )

      # Note: We currently only gather counter and gauge data.
      result = {}
      json['counters'].merge(json['gauges']).each { |k, v|
        # Do a dance in order to get around the fact that Ostrich doesn't prefix
        # JVM-related metrics with "jvm/".
        until_first_slash, slash_rest = k.split('/', 2)
        until_first_underscore, us_rest = until_first_slash.split('_', 2)
        prefix = until_first_underscore
        rest = us_rest.to_s + slash_rest.to_s
        (result[prefix] ||= {})[rest] = v
      }
      result
    end
  end
end
