require "net/http"
require 'timeout'

module Fintop
  module Probe
    extend self

    # Pick out the pids of Finagle servers by probing for "/admin" endpoints
    # on TCP sockets opened by Java processes. Returns an array of Finagle
    # (pid, admin_port) pairs (i.e. 2-element arrays).
    def finagle_pid_admin_port_pairs
      jps_cmd_str = "$JAVA_HOME/bin/jps | grep -v NGServer | grep -v Jps | awk '{print $1}'"
      finagle_pids = `#{jps_cmd_str}`.split.map { |pid|
        lsof_cmd_str = "lsof -P -i tcp -a -p #{pid} | grep LISTEN | awk '{print $9}'"
        m = /\d+/.match(`#{lsof_cmd_str}`)
        m && [pid, m[0]]
      }.compact.select { |pid, port|
        # Probe the "/admin" endpoint.
        begin
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
