require 'json'
require "net/http"

module Fintop
  # Contains functions that gather Finagle application metrics.
  module Metrics
    extend self

    # Query a Finagle server's "/admin/metrics.json" endpoint to produce a hash
    # of metrics.
    def apply(port)
      json_str = Net::HTTP.get(
        URI.parse("http://localhost:#{port}/admin/metrics.json")
      )

      # Return a nested hash keyed by the metric prefix.
      # i.e. { jvm => { uptime => 18251.0, fd_count = 203.0, ... }, ... }
      result = {}
      JSON.parse(json_str).each { |k, v|
        prefix, rest = k.split('/', 2)
        (result[prefix] ||= {})[rest] = v
      }
      result
    end
  end
end
