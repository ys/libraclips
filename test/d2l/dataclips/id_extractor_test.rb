require 'test_helper'

class D2L::Dataclips::IdExtractorTest < Minitest::Unit::TestCase
  def test_it_extracts_correctly_id
    id = 'jcopmmuubebhyotlbspulagvghxx'
    %w{https://dataclips.heroku.com/jcopmmuubebhyotlbspulagvghxx#users-1
       https://dataclips.heroku.com/jcopmmuubebhyotlbspulagvghxx.json#users-1
       jcopmmuubebhyotlbspulagvghxx#users-1
       jcopmmuubebhyotlbspulagvghxx}.each do |url_or_id|
         assert_equal D2L::Dataclips::IdExtractor.new(url_or_id).call, id
    end
  end
end
