require 'test_helper'

class D2L::TransformFunctions::NameValueTest < Minitest::Unit::TestCase
  def valid_dataclip
    fields = ['something','some_value']
    values = (0..10).map do |i|
      Struct.new(*fields.map(&:to_sym)).new("name#{i}", i * 10)
    end
    D2L::Dataclips::Result.new(fields, values)
  end

  def measurement
    D2L::Measurement.new(librato_base_name: 'user.totals')
  end

  def valid_metrics
    metrics = (0..10).map do |i|
      { name: "user.totals.name#{i}", value: i * 10 }
    end
    { gauges: metrics }
  end

  def test_valid_dataclip_is_accepted
    assert D2L::TransformFunctions::NameValue.new.accepts?(valid_dataclip)
  end

  def test_valid_dataclip_is_correctly_transformed
    assert_equal D2L::TransformFunctions::NameValue.new.call(valid_dataclip, measurement), valid_metrics
  end
end
