require 'sequel'
require_relative 'd2l/config'
require_relative 'd2l/dataclips'
require_relative 'd2l/librato'
require_relative 'd2l/migrator'
require_relative 'd2l/measurements'
require_relative 'd2l/poller'

module D2L
  DB = Sequel.connect(Config.database_url)

  def self.run
    poller = Poller.new(poll_interval: Config.poll_interval)
    poller.run
  end
end
