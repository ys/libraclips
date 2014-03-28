require_relative '../config'
require_relative 'base'

module D2L
  module TransformFunctions
    class Default < Base
      def accepts?(dataclip)
        dataclip.has_field?('count') ||
        dataclip.has_field?(/perc/)
      end

      def transform
        Scrolls.log(step: :transform_dataclip, function: :default)
        @librato_base_name = measurement.librato_base_name
        gauges = dataclip.values.each_with_object({}) do |value, metrics|
          if value.respond_to?(:count)
            metric_name = build_name(value)
            metric_value = Float(value.count)
            metrics[metric_name] = { value: metric_value }
          end
          dataclip.matching_fields(/perc/).each do |field|
            metric_name = build_name(value, field)
            metric_value = Float(value.send(field))
            metrics[metric_name] = { value: metric_value }
          end
        end
        { gauges: gauges }
      end

      private
      attr_reader :librato_base_name

      def build_name(value, metric_type = 'count')
        if dataclip.has_field?(/name/)
          "#{librato_base_name}.#{value.send(dataclip.matching_fields(/name/).first)}.#{metric_type}"
        else
          "#{librato_base_name}.#{metric_type}"
        end
      end
    end
  end
end
