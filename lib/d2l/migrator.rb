require_relative 'transformer'
require_relative 'librato'
require_relative 'measurements'

module D2L
  class Migrator
    attr_writer :librato_client, :transformer, :measurements

    def migrate_outdated_measurements
      measurements.outdated.each do |measurement|
        migrate(measurement)
      end
    end

    def migrate(measurement)
      metrics = transformer.call(measurement.dataclip_reference, measurement.librato_base_name)
      librato_client.submit(metrics)
      measurements.just_run!(measurement.id)
    end

    def measurements
      @measurements ||= Measurements.new
    end

    def librato_client
      @librato_client ||= Librato::Client.new
    end

    def transformer
      @transformer ||= Transformer.new
    end
  end
end
