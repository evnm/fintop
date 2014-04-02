require 'test_helper'
require 'fintop/metrics'

class MetricsTest < Test::Unit::TestCase
  def test_process_ostrich_json_parses_valid_json_string
    json_str = %q{{"counters":{"srv\/http\/received_bytes":37},"gauges":{"jvm_uptime":219,"srv\/http\/connections":1}}}
    expected = {
      'srv'=>{'http/received_bytes'=>37,'http/connections'=>1},
      'jvm'=>{'uptime'=>219}
    }
    output = Fintop::Metrics.process_ostrich_json(json_str)

    assert_equal(output, expected)
  end

  def test_process_ostrich_json_throws_on_empty_string
    assert_raise JSON::ParserError do
      Fintop::Metrics.process_ostrich_json("")
    end
  end

  def test_process_ostrich_json_throws_on_invalid_json_string
    assert_raise JSON::ParserError do
      Fintop::Metrics.process_ostrich_json("{j")
    end
  end

  def test_process_metrics_tm_json_parses_valid_json_string
    json_str = %q{{"jvm\/uptime":183.0,"srv\/http\/connections":1.0,"srv\/http\/received_bytes":96}}
    expected = {
      'srv'=>{'http/received_bytes'=>96,'http/connections'=>1.0},
      'jvm'=>{'uptime'=>183.0}
    }
    output = Fintop::Metrics.process_metrics_tm_json(json_str)

    assert_equal(output, expected)
  end

  def test_process_metrics_tm_json_throws_on_empty_string
    assert_raise JSON::ParserError do
      Fintop::Metrics.process_metrics_tm_json("")
    end
  end

  def test_process_metrics_tm_json_throws_on_invalid_json_string
    assert_raise JSON::ParserError do
      Fintop::Metrics.process_metrics_tm_json("{j")
    end
  end
end
