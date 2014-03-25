require_relative 'transformer'
require_relative 'librato'

module D2L
  class Poller
    attr_reader :poll_interval

    def initialize(options = {})
      @poll_interval = options[:poll_interval]
    end

    def run
      loop do
        DB[:measurements].where("run_at IS null OR (run_at < now() - (interval '1 seconds' * run_every_seconds))").each do |row|
          self.call(row[:dataclip_reference], row[:librato_base_name])
          DB[:measurements].where(id: row[:id]).update(run_at: Time.now())
        end
        sleep poll_interval
      end
    end

    def call(dataclip_ref, librato_base_name)
      transformer = Transformer.new(dataclip_ref, librato_base_name)
      metrics = transformer.call
      Librato::Client.new.submit(metrics)
    end

  end
end
