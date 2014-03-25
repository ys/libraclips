require 'test_helper'

class Dataclips::ResultTest < Minitest::Unit::TestCase
  def test_that_fields_are_required
    err = assert_raises StandardError do
      Dataclips::Result.from({ 'fields' => nil, 'values' => [] })
    end
    assert "'fields' is missing", err.message
  end

  def test_that_values_are_required
    err = assert_raises StandardError do
      Dataclips::Result.from({ 'fields' => [], 'values' => nil })
    end
    assert "'values' is missing", err.message
  end

  def test_that_fields_is_an_array
    err = assert_raises StandardError do
      Dataclips::Result.from({ 'fields' => {}, 'values' => [] })
    end
    assert "'fields' is not an array", err.message
  end

  def test_that_values_is_an_array
    err = assert_raises StandardError do
      Dataclips::Result.from({ 'fields' => [], 'values' => {} })
    end
    assert "'values' is not an array", err.message
  end

  def test_empty_fields_raise_error
    err = assert_raises StandardError do
      result = Dataclips::Result.from({ 'fields' => [], 'values' => [[1]] })
    end
    assert "'fields' is empty", err.message
  end

  def test_correctly_formatted_json_returns_a_result
    result = Dataclips::Result.from({ 'fields' => ['count'], 'values' => [[1], [4]] })
    assert 2, result.values.size
    assert_respond_to result.values.first, :count
    assert '1', result.values.count
  end
end
