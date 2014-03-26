module D2L
  class Measurement < Struct.new(:id, :dataclip_reference, :librato_base_name, :run_interval, :run_at)

    def initialize(*args)
      if args.last.is_a? Hash
        args.last.each do |k,v|
          self[k] = v unless v.nil? || !members.include?(k)
        end
      else
        super
      end
    end

    def to_json(*args)
      to_h.to_json(*args)
    end
  end
end

