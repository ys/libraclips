require 'test_helper'

class D2L::TransformFunctions::BaseTest < Minitest::Unit::TestCase

  class MockFunction < D2L::TransformFunctions::Base
    def transform
      { gauges: [{}, {}] }
    end
  end

  def transformed_gauges
    { gauges: [{ source: 'test' }, { source: 'test' }] }
  end

  def test_source_injection
    result = MockFunction.new.call(nil, D2L::Measurement.new(librato_source: 'test'))
    assert_equal result, transformed_gauges
  end
end
