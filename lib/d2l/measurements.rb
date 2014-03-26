require_relative 'measurement'

module D2L
  class Measurements

    def all
      DB[:measurements].all.map do |row|
        Measurement.new(row)
      end
    end

    def outdated
      return enum_for(:outdated) unless block_given?

      DB[:measurements].where("run_at IS null OR (run_at < now() - (interval '1 seconds' * run_interval))").each do |row|
        yield Measurement.new(row)
      end
    end

    def just_run!(id)
      DB[:measurements].where(id: id).update(run_at: Time.now())
    end

    def create(dataclip_reference, librato_base_name, run_interval = nil)
      dataclip_id = D2L::Dataclips::IdExtractor.new(dataclip_reference).call
      run_interval ||= Config.default_run_interval
      id = DB[:measurements].insert(dataclip_reference: dataclip_id,
                                librato_base_name: librato_base_name,
                                run_interval: run_interval)
      Measurement.new(id, dataclip_id, librato_base_name, run_interval)
    end

    def has_dataclip?(dataclip_id)
      dataclip_id = D2L::Dataclips::IdExtractor.new(dataclip_reference).call
      DB[:measurements].where(dataclip_reference: dataclip_id).first
    end
  end
end
