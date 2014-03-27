require 'sequel'
require_relative 'config'

DB = Sequel.connect(D2L::Config.database_url)
