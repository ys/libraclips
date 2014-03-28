require 'simplecov'
SimpleCov.start

require 'dotenv'
Dotenv.load('.env.test')

require 'minitest/autorun'
require 'debugger'
require_relative '../lib/d2l'
require_relative '../lib/d2l/web/app'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'test/vcr_cassettes'
  c.hook_into :webmock
end

module Scrolls
  def log(*args)

  end
end

module D2L
  module Metrics
    def track_time(*args, &block)
      block.call
    end
  end
end
