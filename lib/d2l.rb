require 'sequel'
require_relative 'd2l/dataclips'
require_relative 'd2l/librato'
require_relative 'd2l/migrator'
require_relative 'd2l/measurements'
require_relative 'd2l/poller'

module D2L
  DB = Sequel.connect(ENV['DATABASE_URL'] || 'postgres://localhost:5432/dataclips2librato')

  def self.run
    database_url =
    poll_interval = Integer(ENV['POLL_INTERVAL'] || 10)
    Poller.new(database_url: database_url, poll_interval: poll_interval).run
  end
end