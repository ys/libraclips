require 'test_helper'

class D2L::Librato::ClientTest < Minitest::Unit::TestCase

  def correct_metrics
    {gauges: [{name: 'deploysaurus.users.count', value: 100}]}
  end

  def incorrect_metrics
    {gauges: [{name: 'deploysaurus.users.count'}]}
  end

  def test_correct_metrics_are_submitted
    VCR.use_cassette('librato_success') do
      response = D2L::Librato::Client.new.submit(correct_metrics)
      assert_equal response.status, 200
    end
  end

  def test_incorrect_metrics_are_raising_error
    VCR.use_cassette('librato_failure') do
      err = assert_raises D2L::Librato::Error do
        response = D2L::Librato::Client.new.submit(incorrect_metrics)
      end
      assert_equal err.status, 400
      assert_includes err.message, 'errors'
    end
  end
end
