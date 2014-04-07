# 0.0.2 (4/6/2014)

- Add -a option for displaying info on other users' Finagle processes
- Fetch Java processes in Ruby rather than shelling out to `jps`
- Add -v/--version command-line options
- Add -h/--help command-line options

# 0.0.1 (4/1/2014)

- Initial version of Fintop. Probes stats and threads endpoints of Finagle
  servers built on [TwitterServer](http://twitter.github.io/twitter-server/)
  with either [Ostrich](https://github.com/twitter/ostrich) or
  [MetricsTM](https://github.com/twitter/commons/tree/master/src/java/com/twitter/common/metrics).
  Prints basic statistics in top-like tabular output.
