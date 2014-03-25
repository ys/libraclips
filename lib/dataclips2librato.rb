require 'dotenv'
Dotenv.load
require 'sequel'
require_relative './dataclips'
require_relative './poller'

class Dataclips2Librato
  MEASURE_INTERVAL = 10

  def self.run
    database_url = ENV['DATABASE_URL'] || 'postgres://localhost:5432/dataclips2librato'
    poll_interval = Integer(ENV['POLL_INTERVAL'] || 10)
    Poller.new(database_url: database_url, poll_interval: poll_interval).run
  end
end
