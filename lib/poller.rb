require_relative './transformer'
require_relative './librato'

class Poller
  attr_reader :database_url, :poll_interval

  def initialize(options = {})
    @database_url = options[:database_url]
    @poll_interval = options[:poll_interval]
  end

  def run
    loop do
      db[:measurements].where("run_at IS null OR (run_at < now() - (interval '1 seconds' * run_every_seconds))").each do |row|
        self.call(row[:dataclip_reference], row[:librato_base_name])
        db[:measurements].where(id: row[:id]).update(run_at: Time.now())
      end
      sleep poll_interval
    end
  end

  def call(dataclip_ref, librato_base_name)
    transformer = Transformer.new(dataclip_ref, librato_base_name)
    metrics = transformer.call
    Librato::Client.new.submit(metrics)
  end

  def db
    @db ||= Sequel.connect(database_url)
  end
end
