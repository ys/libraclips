require_relative 'base'

module D2L
  module TransformFunctions
    class NameValueFunc < Base
      def accepts?(dataclip)
        dataclip.fields.size == 2
      end

      def transform
        Scrolls.log(step: :transform_dataclip, function: :name_value)
        metrics = dataclip.values.map do |value|
          metric_name = "#{measurement.librato_base_name}.#{value[dataclip.fields.first]}"
          metric_value = Float(value[dataclip.fields.last])
          { name: metric_name, value: metric_value }
        end
        { gauges: metrics }
      end
    end
  end
end
