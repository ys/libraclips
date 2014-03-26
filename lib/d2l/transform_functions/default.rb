require_relative '../config'

module D2L
  module TransformFunctions
    class Default
      def accepts?(dataclip)
        dataclip.has_field?('count') ||
        dataclip.has_field?(/perc/)
      end

      def call(dataclip, args)
        Scrolls.log(step: :transform_dataclip, function: :base)
        @dataclip = dataclip
        @librato_base_name = args[:librato_base_name] || Config.default_librato_base_name
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
      attr_reader :dataclip, :librato_base_name

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
