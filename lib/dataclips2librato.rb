require 'dotenv'
Dotenv.load
require 'sequel'
require 'pp'
require_relative './dataclips'
require_relative './transformer'
require_relative './librato'

class Dataclips2Librato
  MEASURE_INTERVAL = 10

  def self.run
    @db = Sequel.connect(ENV['DATABASE_URL'])
    loop do
      @db[:measurements].where("run_at IS null OR (run_at < now() - (interval '1 seconds' * run_every_seconds))").each do |row|
        pp row
        self.new.(row[:dataclip_reference], row[:librato_base_name])
      end
      sleep MEASURE_INTERVAL
    end
  end

  def call(dataclip_ref, librato_base_name)
    transformer = Transformer.new(dataclip_ref, librato_base_name)
    metrics = transformer.call
    Librato::Client.new.submit(metrics)
  end
end
