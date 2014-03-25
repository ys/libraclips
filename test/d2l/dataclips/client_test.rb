require 'test_helper'

class D2L::Dataclips::ClientTest < Minitest::Unit::TestCase

  def test_fetch_is_not_nil_with_correct_params
    VCR.use_cassette('dataclips') do
      [
        'https://dataclips.heroku.com/jcopmmuubebhyotlbspulagvghxx#users-1',
        'https://dataclips.heroku.com/jcopmmuubebhyotlbspulagvghxx.json#users-1',
        'jcopmmuubebhyotlbspulagvghxx#users-1',
        'jcopmmuubebhyotlbspulagvghxx'
      ].each do |url_or_id|
        refute_equal nil, D2L::Dataclips::Client.new.fetch(url_or_id)
      end
    end
  end

  def test_fetch_has_correct_values
    VCR.use_cassette('dataclips') do
      result = D2L::Dataclips::Client.new.fetch('jcopmmuubebhyotlbspulagvghxx')
      assert_equal ['count'], result.fields
      assert_equal 1, result.values.size
      assert_equal '1', result.values.first.count
    end
  end

  def test_fetch_with_error_returns_nil_object
    client = D2L::Dataclips::Client.new
    def client.open(*args)
      raise OpenURI::HTTPError.new('not found', nil)
    end
    result = client.fetch('some_dataclip')
    assert_equal [], result.fields
    assert_equal [], result.values
  end
end
