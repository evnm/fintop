# fintop

A top-like utility for monitoring [Finagle](http://github.com/twitter/finagle) servers.

## Installation

The `fintop` gem hasn't been published yet, so is currently only usable from
source. To install `fintop` locally, clone this repository and run
`rake install` from within the repository's root directory.

## Usage

`fintop` is intended to be used in a similar fashion as the `top` suite of
monitoring programs. For example, given two Finagle servers running locally,
running `fintop` could look like this:

    $ fintop
    Processes: 2, Threads: 34 total, 22 runnable, 12 waiting

    PID     ADMIN   #THREADS  #RUNNABLE   #WAITING   #TIMEDWAITING
    39549   9990    17        11          4          2
    40595   1110    17        11          4          2

## Contributing

1. Fork it ( http://github.com/<my-github-username>/fintop/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
