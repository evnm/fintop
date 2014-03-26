require 'fintop/metrics'

module Fintop
  # Contains functions that gather and print operational data on local
  # Finagle processes.
  module Printer
    extend self

    # Given an array of (pid, admin_port) pairs, gather data and print output.
    def apply(pid_port_pairs)
      if pid_port_pairs.empty?
        puts "Finagle processes: 0"
        exit
      end

      # Create a hash of pid=>ThreadsData objects.
      threads_data_hash = Hash[
        pid_port_pairs.map { |pid, port|
          [pid, Fintop::ThreadsData.new(port)]
        }
      ]

      metrics_hash = Hash[
        pid_port_pairs.map { |pid, port|
          [pid, Fintop::Metrics.apply(port)]
        }
      ]

      print_header(threads_data_hash)

      pid_port_pairs.each { |pid, port|
        threads_data = threads_data_hash[pid]
        metrics = metrics_hash[pid]

        printf(
          @@row_format_str,
          pid,
          port,
          metrics['jvm/num_cpus'],
          threads_data.num_threads,
          threads_data.num_runnable,
          threads_data.num_waiting,
          threads_data.num_timed_waiting
        )
      }
    end

    private

    @@row_format_str = "%-7s %-6s %-5s %-5s %-6s %-7s %-8s\n"

    # Print a total process/thread synopsis and column headers.
    def print_header(threads_data_hash)
      total_threads = threads_data_hash.values.map { |t|
        t.num_threads
      }.inject(:+)

      runnable_threads = threads_data_hash.values.map { |t|
        t.num_runnable
      }.inject(:+)

      waiting_threads = threads_data_hash.values.map { |t|
        t.num_waiting + t.num_timed_waiting
      }.inject(:+)

      puts "Finagle processes: #{threads_data_hash.size}, "\
           "Threads: #{total_threads} total, "\
           "#{runnable_threads} runnable, "\
           "#{waiting_threads} waiting"
      puts
      printf(
        @@row_format_str,
        "PID",
        "PORT",
        "CPU",
        "#TH",
        "#RUN",
        "#WAIT",
        "#TWAIT"
      )
    end
  end
end