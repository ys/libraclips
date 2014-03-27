require 'test_helper'

class D2L::TransformFunctions::DefaultTest < Minitest::Unit::TestCase
  def valid_dataclip
    fields = ['name','count', 'perc100']
    values = (0..10).map do |i|
      Struct.new(*fields.map(&:to_sym)).new("name#{i}", i * 10, i * 100)
    end
    D2L::Dataclips::Result.new(fields, values)
  end

  def measurement
    D2L::Measurement.new(librato_base_name: 'default')
  end

  def valid_metrics
    metrics = {}
    (0..10).each do |i|
        metrics["default.name#{i}.count"]   = { value: i * 10 }
        metrics["default.name#{i}.perc100"] = { value: i * 100 }
    end
    { gauges: metrics }
  end

  def test_valid_dataclip_is_accepted
    assert D2L::TransformFunctions::Default.new.accepts?(valid_dataclip)
  end

  def test_valid_dataclip_is_correctly_transformed
    assert_equal D2L::TransformFunctions::Default.new.call(valid_dataclip, measurement), valid_metrics
  end
end
