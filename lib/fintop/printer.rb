require 'fintop/metrics'
require 'fintop/threads'

module Fintop
  # Contains functions that gather and print operational data on local
  # Finagle processes.
  module Printer
    extend self

    # Given an array of Fintop::Probe::FinagleProcess objects, gather data
    # and print output.
    #
    # @param finagle_procs [Array<FinagleProcess>]
    def apply(finagle_procs)
      if finagle_procs.empty?
        puts 'Finagle processes: 0'
        exit
      end

      # Create a hash of pid=>ThreadsData objects.
      threads_data_hash = Hash[
        finagle_procs.map { |finp|
          [finp.pid, Fintop::ThreadsData.new(finp.admin_port)]
        }
      ]

      metrics_hash = Hash[
        finagle_procs.map { |finp|
          [finp.pid, Fintop::Metrics.apply(finp)]
        }
      ]

      print_header(threads_data_hash)

      finagle_procs.each { |finp|
        threads_data = threads_data_hash[finp.pid]
        metrics = metrics_hash[finp.pid]

        tx_bytes, rx_bytes = [0, 0]
        metrics.values.each { |scoped_metrics|
          scoped_metrics.each { |k, v|
            if not (k =~ /\/sent_bytes$/).nil?
              tx_bytes = v / 1024
            elsif not (k =~ /\/received_bytes$/).nil?
              rx_bytes = v / 1024
            end
          }
        }

        printf(
          @@row_format_str,
          finp.pid,
          finp.admin_port,
          metrics['jvm']['num_cpus'].to_f,
          threads_data.num_threads,
          threads_data.num_non_daemon,
          threads_data.num_runnable,
          threads_data.num_waiting,
          threads_data.num_timed_waiting,
          tx_bytes,
          rx_bytes
        )
      }
    end

    # Print fintop version.
    def print_version
      require 'fintop/version'
      puts "fintop version #{Fintop::VERSION}"
    end

    # Print help output.
    def print_help
      puts 'usage: fintop [-v|--version] [-h|--help] [-a]'
      puts
      puts 'Options:'
      printf(@@option_format_str, '-a', 'Display info about other users\' ' \
                                        'Finagle processes as well as your own')
      printf(@@option_format_str, '-v, --version',
        'Print the version number of Fintop being run')
      printf(@@option_format_str, '-h, --help', 'Print help output')
      puts
      puts 'Column Labels:'
      @@columns.each { |label, description|
        printf(@@column_label_format_str, label, description)
      }
    end

    private

    @@row_format_str = "%-7s %-6s %-5s %-5s %-6s %-6s %-7s %-8s %-10s %-10s\n"

    # Help output format strings.
    @@option_format_str =       "   %s\n      %s\n"
    @@column_label_format_str = "   %-8s %s\n"
    @@columns = [
      ['PID',   'The process identifier of the Finagle process'],
      ['PORT',  'The admin port opened by the process'],
      ['CPU',   'The number of CPUs allocated to the process'],
      ['#TH',   'The total number of threads within the process'],
      ['#NOND', 'The number of non-daemon threads within the process'],
      ['#RUN',  'The number of runnable threads within the process'],
      ['#WAIT', 'The number of waiting threads within the process'],
      ['#TWAIT','The number of threads within the process that are waiting on a timer'],
      ['TXKB',  'The sum of data (in KB) transmitted by the Finagle process'],
      ['RXKB',  'The sum of data (in KB) received by the Finagle process']
    ]

    # Print a total process/thread synopsis and column headers.
    #
    # @param threads_data_hash [Hash<Fixnum, ThreadsData>] a hash of pids and
    # their corresponding ThreadsData objects.
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
      printf(@@row_format_str, *(@@columns.map { |label, desc| label }))
    end
  end
end
