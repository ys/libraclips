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
      Scrolls.log(step: :migrate_measurement, id: measurement.id)
      metrics = transformer.call(measurement.dataclip_reference, measurement.librato_base_name)
      librato_client.submit(metrics)
      measurements.just_run!(measurement.id)
      Scrolls.log(step: :migrated_measurement, id: measurement.id)
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
