require 'dotenv/tasks'

namespace :d2l do
  desc "Run poller"
  task poll: :environment do
    D2L.run
  end

  namespace :dev do
    desc "Run poller with Dotenv"
    task poll: [:environment, :dotenv] do
      D2L.run
    end
  end

  desc "Add a measurement to be watched"
  task add_measurement: [:environment, :dotenv] do
    dataclip_reference = ENV['DATACLIP_REFERENCE']
    librato_base_name = ENV['LIBRATO_BASE_NAME']
    run_interval = ENV['RUN_INTERVAL']
    D2L::Measurement.create(dataclip_reference: dataclip_reference,
                            librato_base_name:  librato_base_name,
                            run_interval:       run_interval)
  end
end

task :console do
  require 'pry'
  require 'dotenv'
  Dotenv.load
  require_relative '../../d2l'
  ARGV.clear
  Pry.start
end

task :environment do
  require_relative '../../d2l'
end
