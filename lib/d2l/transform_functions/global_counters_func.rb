require_relative 'base'

module D2L
  module TransformFunctions
    class GlobalCountersFunc < Base
      def accepts?(dataclip)
        dataclip.fields.size == 1 && dataclip.values.size == 1
      end

      def transform
        Scrolls.log(step: :transform_dataclip, function: :global_counters)
        value = dataclip.values.first
        metric_name = measurement.librato_base_name
        metric_value = Float(value[dataclip.fields.first])
        { gauges: [{ name: metric_name, value: metric_value}] }
      end
    end
  end
end
