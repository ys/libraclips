if ENV['RACK_ENV'] != 'production'
  require 'dotenv'
  Dotenv.load!
end
require 'sequel'
require_relative 'd2l/config'
require_relative 'd2l/database'
require_relative 'd2l/dataclips'
require_relative 'd2l/librato'
require_relative 'd2l/migrator'
require_relative 'd2l/measurement'
