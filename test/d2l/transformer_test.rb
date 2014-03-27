require 'test_helper'

class D2L::TransformerTest < Minitest::Unit::TestCase

  def measurement
    D2L::Measurement.new(dataclip_reference: 'dataclip_ref',
                    librato_base_name: 'default')
  end

  def test_transform
    dataclip = MiniTest::Mock.new
    dataclip.expect :empty?, false
    dataclips_client = MiniTest::Mock.new
    dataclips_client.expect :fetch, dataclip, ['dataclip_ref']
    transform_function = MiniTest::Mock.new
    transform_function.expect :call, :bla, [dataclip, measurement]
    transformer = D2L::Transformer.new
    transformer.dataclips_client = dataclips_client
    transformer.transform_function = transform_function
    assert_equal transformer.call(measurement), :bla
    transform_function.verify
  end

  def test_transform_with_empty_dataclip
    dataclip = MiniTest::Mock.new
    dataclip.expect :empty?, true
    dataclips_client = MiniTest::Mock.new
    dataclips_client.expect :fetch, dataclip, ['dataclip_ref']
    transformer = D2L::Transformer.new
    transformer.dataclips_client = dataclips_client
    assert_equal transformer.call(measurement), nil
  end
end
