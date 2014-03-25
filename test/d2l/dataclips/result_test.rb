require 'test_helper'

class D2L::Dataclips::ResultTest < Minitest::Unit::TestCase
  def test_that_fields_are_required
    err = assert_raises StandardError do
      D2L::Dataclips::Result.from({ 'fields' => nil, 'values' => [] })
    end
    assert_equal "'fields' is missing", err.message
  end

  def test_that_values_are_required
    err = assert_raises StandardError do
      D2L::Dataclips::Result.from({ 'fields' => [], 'values' => nil })
    end
    assert_equal "'values' is missing", err.message
  end

  def test_that_fields_is_an_array
    err = assert_raises StandardError do
      D2L::Dataclips::Result.from({ 'fields' => {}, 'values' => [] })
    end
    assert_equal "'fields' is not an array", err.message
  end

  def test_that_values_is_an_array
    err = assert_raises StandardError do
      D2L::Dataclips::Result.from({ 'fields' => [], 'values' => {} })
    end
    assert_equal "'values' is not an array", err.message
  end

  def test_empty_fields_raise_error
    err = assert_raises StandardError do
      result = D2L::Dataclips::Result.from({ 'fields' => [], 'values' => [[1]] })
    end
    assert_equal "'fields' is empty", err.message
  end

  def test_correctly_formatted_json_returns_a_result
    result = D2L::Dataclips::Result.from({ 'fields' => ['count'], 'values' => [['1'], ['4']] })
    assert_equal 2, result.values.size
    assert_respond_to result.values.first, :count
    assert_equal '1', result.values.first.count
  end
end
