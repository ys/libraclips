require 'pp'
module D2L
  module TransformFunctions
    class GlobalCounters
      def accepts?(dataclip)
        dataclip.has_field?('count') && dataclip.values.size == 1
      end

      def call(dataclip, args = {})
        Scrolls.log(step: :transform_dataclip, function: :global_counters)
        @args = args
        value = dataclip.values.first
        metric_name = "#{librato_base_name}.count"
        metric_value = Float(value.count)
        { gauges: [{ name: metric_name, value: metric_value}] }
      end

      private
      attr_reader :args

      def librato_base_name
        args[:librato_base_name]
      end
    end
  end
end
