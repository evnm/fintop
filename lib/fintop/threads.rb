require 'json'

module Fintop
  class ThreadsData
    attr_reader :num_threads
    attr_reader :num_runnable
    attr_reader :num_waiting
    attr_reader :num_timed_waiting

    # Initialize a ThreadsData object for a Finagle server's on a given
    # port's "/admin/threads" endpoint.
    def initialize(port)
      json_str = `curl -s localhost:#{port}/admin/threads`
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
    end
  end
end
