# fintop

A top-like utility for monitoring [Finagle](http://github.com/twitter/finagle) servers.

## Installation

### From RubyGems.org

`fintop` is distributed as [an executable Ruby gem](https://rubygems.org/gems/fintop).
To install it from the RubyGems.org, simply run `gem install fintop`.

### From source

To install `fintop` locally from source, clone this repository and run
`rake install` from within the repository's root directory.

## Usage

`fintop` is intended to be used in a similar fashion as the `top` suite of
monitoring programs. For example, given two Finagle servers running locally,
running `fintop` could look like this:

    $ fintop
    Finagle processes: 2, Threads: 44 total, 30 runnable, 14 waiting

    PID     PORT   CPU   #TH   #NOND  #RUN   #WAIT   #TWAIT   TXKB       RXKB
    14909   1110   4.0   22    1      15     4       3        351        363
    14905   9990   4.0   22    1      15     4       3        325        823

## Contributing

1. [Fork the repository](http://github.com/evnm/fintop/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. [Create new Pull Request](https://help.github.com/articles/creating-a-pull-request)
