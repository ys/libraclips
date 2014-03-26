require_relative 'transformer'
require_relative 'librato'
require_relative 'measurements'

module D2L
  class Migrator
    attr_writer :librato_client, :transformer, :measurements

    def migrate_outdated_measurements
      measurements.outdated.each do |measurement|
        migrate(measurement.dataclip_reference, measurement.librato_base_name)
        measurements.just_run!(measurement.id)
      end
    end

    def migrate(dataclip_ref, librato_base_name)
      metrics = transformer.call(dataclip_ref, librato_base_name)
      librato_client.submit(metrics)
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
