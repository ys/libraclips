module D2L
  class Measurements
    def outdated
      return enum_for(:outdated) unless block_given?

      DB[:measurements].where("run_at IS null OR (run_at < now() - (interval '1 seconds' * run_interval))").each do |row|
        yield Measurement.new(row[:id], row[:dataclip_reference], row[:librato_base_name])
      end
    end

    def just_run!(id)
      DB[:measurements].where(id: id).update(run_at: Time.now())
    end

    def create(dataclip_reference, librato_base_name, run_interval = Config.default_run_interval)
      dataclip_id = D2L::Dataclips::IdExtractor.new(dataclip_reference).call
      DB[:measurements].insert(dataclip_reference: dataclip_id,
                                librato_base_name: librato_base_name,
                                run_interval: run_interval)
    end

    def has_dataclip?(dataclip_id)
      dataclip_id = D2L::Dataclips::IdExtractor.new(dataclip_reference).call
      DB[:measurements].where(dataclip_reference: dataclip_id).first
    end
  end

  class Measurement < Struct.new(:id, :dataclip_reference, :librato_base_name, :run_interval)
    def to_json(*args)
      { id: id,
        dataclip_reference: dataclip_reference,
        librato_base_name: librato_base_name,
        run_interval: run_interval }.to_json
    end
  end
end

