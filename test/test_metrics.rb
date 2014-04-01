require 'test_helper'
require 'fintop/metrics'

class MetricsTest < Test::Unit::TestCase
  def test_process_ostrich_json
    json_str = %q{{"counters":{"srv\/http\/received_bytes":37,"srv\/http\/requests":4},"gauges":{"jvm_uptime":219,"srv\/http\/connections":1}}}
    expected = {'srv'=>{'http/received_bytes'=>37,'http/requests'=>4,'http/connections'=>1},'jvm'=>{'uptime'=>219}}
    output = Fintop::Metrics.process_ostrich_json(json_str)

    assert_equal(output, expected)
  end
end
