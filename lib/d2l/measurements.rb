module D2L
  class Measurements
    def outdated
      return enum_for(:outdated) unless block_given?

      DB[:measurements].where("run_at IS null OR (run_at < now() - (interval '1 seconds' * run_every_seconds))").each do |row|
        yield Measurement.new(row[:id], row[:dataclip_reference], row[:librato_base_name])
      end
    end

    def just_run!(id)
      DB[:measurements].where(id: id).update(run_at: Time.now())
    end
  end

  class Measurement < Struct.new(:id, :dataclip_reference, :librato_base_name)
  end
end

