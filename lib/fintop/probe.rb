require "net/http"
require 'timeout'

module Fintop
  # Contains functions for probing a system to discover Finagle server
  # processes running locally.
  module Probe
    extend self

    # Probe localhost for Finagle servers.
    #
    # Probing targets are Java processes listening on a TCP socket serving
    # the path "/admin". Function returns an array of Finagle server
    # (pid, admin_port) pairs (i.e. 2-element arrays).
    def apply
      # Invoke jps and filter out nailgun servers and the jps process itself.
      jps_cmd_str = "$JAVA_HOME/bin/jps | grep -v NGServer | grep -v Jps | awk '{print $1}'"

      finagle_pids = `#{jps_cmd_str}`.split.map { |pid|
        # Filter for the processes that are listening on a TCP port.
        lsof_cmd_str = "lsof -P -i tcp -a -p #{pid} | grep LISTEN | awk '{print $9}'"
        port_match = /\d+/.match(`#{lsof_cmd_str}`)
        port_match && [pid, port_match[0]]
      }.compact.select { |pid, port|
        # Probe the "/admin" endpoint.
        begin
          # Manual timeout to bail out of hung requests to un-listened-on ports.
          Timeout::timeout(0.1) do
            Net::HTTP.start('localhost', port) { |http|
              http.head('/admin').code.to_i == 200
            }
          end
        rescue Errno::ECONNREFUSED, Timeout::Error
          false
        end
      }.compact
    end
  end
end
