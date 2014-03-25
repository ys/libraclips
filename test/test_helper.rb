require 'minitest/autorun'
require 'debugger'
require_relative '../lib/d2l'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'test/vcr_cassettes'
  c.hook_into :webmock
end
