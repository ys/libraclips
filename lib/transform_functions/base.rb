module TransformFunctions
  class Base
    def accepts?(dataclip)
      dataclip.has_field?('count')
    end

    def call(dataclip, options = {})
      @dataclip = dataclip
      @options = options
      dataclip.values.each_with_index.map do |value, i|
        metric_name = build_name(value, i)
        metric_value = Float(value.count)
        { name: metric_name,
          value: metric_value
        }
      end
    end

    private
    attr_reader :dataclip, :options

    def build_name(value, index, metric_type = 'count')
      base_name = if librato_base_name
                    "#{librato_base_name}."
                  else
                    ""
                  end
      case
      when dataclip.has_field?(/name/)
        "#{base_name}.#{value.send(dataclip.matching_fields(/name/).first)}.#{metric_type}"
      when dataclip.values.size == 1
        "#{base_name}.#{metric_type}"
      else
        "#{base_name}.#{index}.#{metric_type}"
      end
    end

    def librato_base_name
      options[:librato_base_name]
    end
  end
end
