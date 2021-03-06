require 'json'
require 'net/http'

module Fintop
  # Container class for data gathered from a Finagle server's
  # thread-dump endpoint.
  class ThreadsData
    attr_reader :num_threads
    attr_reader :num_runnable
    attr_reader :num_waiting
    attr_reader :num_timed_waiting
    attr_reader :num_non_daemon

    # Initialize a ThreadsData object for a Finagle server's on a given
    # port's "/admin/threads" endpoint.
    #
    # @param admin_port [Fixnum]
    def initialize(admin_port)
      json_str = Net::HTTP.get(
        URI.parse("http://localhost:#{admin_port}/admin/threads")
      )

      @threads = JSON.parse(json_str)['threads'].to_a
      @num_threads = @threads.size

      @num_runnable = @threads.count { |tid, thread|
        thread['state'] == 'RUNNABLE'
      }

      @num_waiting = @threads.count { |tid, thread|
        thread['state'] == 'WAITING'
      }

      @num_timed_waiting = @threads.count { |tid, thread|
        thread['state'] == 'TIMED_WAITING'
      }

      @num_non_daemon = @threads.count { |tid, thread|
        thread['daemon'] == false
      }
    end
  end
end
