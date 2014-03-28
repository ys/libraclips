require_relative 'metrics'
require_relative 'transformer'
require_relative 'librato'
require_relative 'measurement'

module D2L
  class Migrator
    attr_writer :librato_client, :transformer, :measurements

    def migrate_outdated_measurements
      measurements.outdated.each do |measurement|
        migrate(measurement)
      end
    end

    def migrate(measurement)
      D2L::Metrics.track_time(:migration, measurement_id: measurement.id) do
        metrics = transformer.call(measurement)
        librato_client.submit(metrics)
        measurements.just_run!(measurement.id)
      end
    rescue StandardError => e
      Scrolls.log(error: e.class, message: e.message, measurement: measurement.id)
    end

    def measurements
      @measurements ||= Measurement
    end

    def librato_client
      @librato_client ||= Librato::Client.new
    end

    def transformer
      @transformer ||= Transformer.new
    end
  end
end
