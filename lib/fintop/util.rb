module Fintop
  module Util
    extend self

    # Pick out the pids of Finagle servers by probing for "/admin" endpoints
    # on TCP sockets opened by Java processes. Returns an array of Finagle
    # (pid, admin_port) pairs (i.e. 2-element arrays).
    def finagle_pid_admin_port_pairs
      finagle_pids = `$JAVA_HOME/bin/jps -q`.split.map { |pid|
        m = /\d+/.match(`lsof -P -i tcp -a -p #{pid} | grep LISTEN | awk '{print $9}'`)
        m && [pid, m[0]]
      }.compact.select { |pid, port|
        not `curl -m 1 -s localhost:#{port}/admin`.empty?
      }.compact
    end
  end
end
