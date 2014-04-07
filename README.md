# fintop

A `top`-like utility for monitoring [Finagle](http://github.com/twitter/finagle)
services.

`fintop` is a command-line program that gathers and prints abbreviated monitoring
information on local processes running Finagle clients or servers. It is loosely
modeled on [top](http://en.wikipedia.org/wiki/Top_(software)), but doesn't
strictly adhere to `top`-style output.

For example, given two Finagle servers running locally, running `fintop` could
look like this:

    $ fintop
    Finagle processes: 2, Threads: 44 total, 30 runnable, 14 waiting

    PID     PORT   CPU   #TH   #NOND  #RUN   #WAIT   #TWAIT   TXKB       RXKB
    14909   1110   4.0   22    1      15     4       3        351        363
    14905   9990   4.0   22    1      15     4       3        325        823

For more details on usage and explanations of all abbreviations used in the
output, run `fintop -h`.

## Installation

### From RubyGems.org

`fintop` is distributed as [an executable Ruby gem](https://rubygems.org/gems/fintop).
To install it from RubyGems.org, simply run `gem install fintop`.

### From source

To install `fintop` locally from source, clone this repository and run
`rake install` from within the repository's root directory.

## Caveats

`fintop` currently prints static output rather than continously refreshing. In
order to achieve periodic monitoring akin to `top`, combine it with the `watch`
command:

    $ watch fintop

Mac users: OS X does not ship with a built-in `watch` binary but one can be
installed via [Homebrew](http://brew.sh) by running `brew install watch`.

## Support

The best way to report bugs or request features is to
[file an issue on GitHub](https://github.com/evnm/fintop/issues). To chat about
`fintop` or get support on anything Finagle-related, check out the
[finaglers mailing list](https://groups.google.com/forum/#!forum/finaglers) or
the `#finagle` IRC channel on Freenode.

## Contributing

1. [Fork the repository](http://github.com/evnm/fintop/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. [Create new Pull Request](https://help.github.com/articles/creating-a-pull-request)
