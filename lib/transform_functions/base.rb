module TransformFunctions
  class Base
    def accepts?(dataclip)
      dataclip.has_field?('count')
    end

    def call(dataclip, options = {})
      @dataclip = dataclip
      @options = options
      dataclip.values.each_with_object({}) do |value, metrics|
        metric_name = build_name(value)
        metric_value = Float(value.count)
        metrics[metric_name] = { value: metric_value }
      end
    end

    private
    attr_reader :dataclip, :options

    def build_name(value, metric_type = 'count')
      base_name = if librato_base_name
                    "#{librato_base_name}."
                  else
                    ""
                  end
      if dataclip.has_field?(/name/)
        "#{base_name}#{value.send(dataclip.matching_fields(/name/).first)}.#{metric_type}"
      else
        "#{base_name}#{metric_type}"
      end
    end

    def librato_base_name
      options[:librato_base_name]
    end
  end
end
