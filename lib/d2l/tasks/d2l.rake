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
    dataclip_ref = ENV['DATACLIP_REFERENCE']
    librato_base_name = ENV['LIBRATO_BASE_NAME']
    run_interval = ENV['RUN_INTERVAL']
    D2L::Measurements.new.create(dataclip_ref, librato_base_name, run_interval)
  end
end

task :environment do
  require_relative "../../d2l"
end
