require 'test_helper'

class D2L::Dataclips::ResultTest < Minitest::Unit::TestCase
  def test_that_fields_are_required
    err = assert_raises D2L::Dataclips::Error do
      D2L::Dataclips::Result.from({ 'fields' => nil, 'values' => [] })
    end
    assert_equal err.message, "'fields' is missing"
  end

  def test_that_values_are_required
    err = assert_raises D2L::Dataclips::Error do
      D2L::Dataclips::Result.from({ 'fields' => [], 'values' => nil })
    end
    assert_equal err.message, "'values' is missing"
  end

  def test_that_fields_is_an_array
    err = assert_raises D2L::Dataclips::Error do
      D2L::Dataclips::Result.from({ 'fields' => {}, 'values' => [] })
    end
    assert_equal err.message, "'fields' is not an array"
  end

  def test_that_values_is_an_array
    err = assert_raises D2L::Dataclips::Error do
      D2L::Dataclips::Result.from({ 'fields' => [], 'values' => {} })
    end
    assert_equal err.message, "'values' is not an array"
  end

  def test_empty_fields_raise_error
    err = assert_raises D2L::Dataclips::Error do
      result = D2L::Dataclips::Result.from({ 'fields' => [], 'values' => [[1]] })
    end
    assert_equal err.message, "'fields' is empty"
  end

  def test_more_fields_than_in_values_raise_error
    err = assert_raises D2L::Dataclips::Error do
      result = D2L::Dataclips::Result.from({ 'fields' => ['a', 'b'], 'values' => [[1]] })
    end
    assert_equal err.message, "value '[1]' has not the right fields [:a, :b]"
  end

  def test_correctly_formatted_json_returns_a_result
    result = D2L::Dataclips::Result.from({ 'fields' => ['count'], 'values' => [['1'], ['4']] })
    assert_equal result.values.size, 2
    assert_respond_to result.values.first, :count
    assert_equal result.values.first.count, '1'
    assert_equal result.values.first['count'], '1'
  end

  def test_empty_returns_if_values_is_empty
    result = D2L::Dataclips::Result.new([], [])
    assert result.empty?
  end
end
