require 'test_helper'

class D2L::TransformFunctions::GlobalCountersTest < Minitest::Unit::TestCase
  def valid_dataclip
    fields = ['some_value']
    values = [Struct.new(:some_value).new(10)]
    D2L::Dataclips::Result.new(fields, values)
  end

  def measurement
    D2L::Measurement.new(librato_base_name: 'user.totals')
  end

  def valid_metrics
    { gauges: [{ name: 'user.totals', value: 10 }]}
  end

  def test_valid_dataclip_is_accepted
    assert D2L::TransformFunctions::GlobalCounters.new.accepts?(valid_dataclip)
  end

  def test_valid_dataclip_is_correctly_transformed
    assert_equal D2L::TransformFunctions::GlobalCounters.new.call(valid_dataclip, measurement), valid_metrics
  end
end
