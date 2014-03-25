require_relative 'migrator'

module D2L
  class Poller
    attr_reader :poll_interval

    def initialize(options = {})
      @poll_interval = options[:poll_interval]
    end

    def run
      loop do
        Migrator.new.migrate_outdated_measurements
        sleep poll_interval
      end
    end
  end
end
