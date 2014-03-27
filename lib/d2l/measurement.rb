module D2L
  class Measurement < Sequel::Model
    def before_create
      self.dataclip_reference = extract_id(self.dataclip_reference)
      self.run_interval ||= Config.default_run_interval
      super
    end

    def self.outdated
      return enum_for(:outdated) unless block_given?

      where(outdated_condition).each do |measurement|
        yield measurement
      end
    end

    def self.just_run!(id)
      Measurement[id].update(run_at: Time.now())
    end

    def has_dataclip?(dataclip_id)
      where(dataclip_reference: extract_id(dataclip_id)).first
    end

    def to_json(*args)
      values.to_json
    end

    private

    def extract_id(url_or_id)
      D2L::Dataclips::IdExtractor.new(url_or_id).call
    end

    def self.outdated_condition
      # Non run measurement or last run is over interval in seconds
      "run_at IS null OR (run_at < now() - (interval '1 seconds' * run_interval))".freeze
    end
  end
end
