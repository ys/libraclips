require 'test_helper'

# TODO: test differently, fallback to default is hard to test when adding functions
class D2L::TransformFunctionsTest < Minitest::Unit::TestCase
  def test_find_global_counter
    fields = ['some_value']
    values = [Struct.new(:some_value).new(10)]
    dataclip = D2L::Dataclips::Result.new(fields, values)
    assert_kind_of D2L::TransformFunctions::GlobalCountersFunc, D2L::TransformFunctions.find_for(dataclip)
  end

  def test_find_name_value
    fields = ['some_value', 'another']
    values = [Struct.new(:some_value).new(10)]
    dataclip = D2L::Dataclips::Result.new(fields, values)
    assert_kind_of D2L::TransformFunctions::NameValueFunc, D2L::TransformFunctions.find_for(dataclip)
  end

  def test_fall_to_default
    dataclip = D2L::Dataclips::Result.new([''], ['', '', ''])
    assert_kind_of D2L::TransformFunctions::Default, D2L::TransformFunctions.find_for(dataclip)
  end
end
