require 'json'
require "net/http"

module Fintop
  # Contains functions that gather Finagle application metrics.
  module Metrics
    extend self

    # Query a Finagle server's "/admin/metrics.json" endpoint to produce a hash
    # of metrics.
    def apply(port, prefix="")
      json_str = Net::HTTP.get(
        URI.parse("http://localhost:#{port}/admin/metrics.json")
      )

      Hash[
        JSON.parse(json_str).select { |k, v|
          k.start_with? prefix
        }
      ]
    end
  end
end
