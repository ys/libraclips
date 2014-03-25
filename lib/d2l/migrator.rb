require_relative 'transformer'
require_relative 'librato'
require_relative 'measurements'

module D2L
  class Migrator
    def migrate_outdated_measurements
      measurements = Measurements.new
      measurements.outdated.each do |measurement|
        migrate(measurement.dataclip_reference, measurement.librato_base_name)
        measurements.just_run!(measurement.id)
      end
    end

    def migrate(dataclip_ref, librato_base_name)
      transformer = Transformer.new(dataclip_ref, librato_base_name)
      metrics = transformer.call
      Librato::Client.new.submit(metrics)
    end
  end
end
