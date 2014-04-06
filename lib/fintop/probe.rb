require 'net/http'
require 'sys/proctable'
require 'timeout'

module Fintop
  # Contains functions for probing a system to discover Finagle server
  # processes running locally.
  module Probe
    extend self

    class FinagleProcess
      attr_reader :pid
      attr_reader :admin_port
      attr_reader :stats_lib

      def initialize(pid, admin_port, stats_lib)
        @pid = pid
        @admin_port = admin_port
        @stats_lib = stats_lib
      end
    end

    # Probe localhost for Finagle servers.
    #
    # Probing targets are Java processes listening on a TCP socket serving
    # the path "/admin". Function returns an array of FinagleProcess objects
    def apply
      java_ps = Sys::ProcTable.ps.select { |s| s.comm == 'java' }

      listening_java_ps = java_ps.map { |s|
        # Filter by user, pid, and existence of a listened-on TCP port.
        lsof_cmd_str = "lsof -P -i tcp -a -p #{s.pid} " \
                       "| grep LISTEN " \
                       "| awk '{print $9}'"
        port_match = /\d+/.match(`#{lsof_cmd_str}`)
        port_match && [s.pid, port_match[0]]
      }.compact

      listening_java_ps.map { |pid, admin_port|
        # Probe the possible ping endpoints to determine which (if any) stats
        # library is in use.
        begin
          # Manual timeout to bail out of hung requests to un-listened-on ports.
          Timeout::timeout(0.3) do
            if is_resolvable(admin_port, '/admin/metrics.json')
              FinagleProcess.new(pid, admin_port, :metrics_tm)
            elsif is_resolvable(admin_port, '/stats.json')
              FinagleProcess.new(pid, admin_port, :ostrich)
            else
              nil
            end
          end
        rescue Errno::ECONNREFUSED, Timeout::Error
          nil
        end
      }.compact
    end

    # Returns true if localhost:admin_port/path is resolvable.
    #
    # @param admin_port [Fixnum]
    # @param path [String]
    def is_resolvable(admin_port, path)
      Net::HTTP.start('localhost', admin_port) { |http|
        http.head(path).code.to_i == 200
      }
    end
  end
end
