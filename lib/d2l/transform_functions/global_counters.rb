require 'pp'
module D2L
  module TransformFunctions
    class GlobalCounters
      def accepts?(dataclip)
        dataclip.has_field?('count') && dataclip.values.size == 1
      end

      def call(dataclip, options = {})
        Scrolls.log(step: :transform_dataclip, function: :global_counters)
        @options = options
        value = dataclip.values.first
        metric_name = "#{librato_base_name}.count"
        metric_value = Float(value.count)
        { gauges: [{ name: metric_name, value: metric_value}] }
      end

      private
      attr_reader :options

      def librato_base_name
        options[:librato_base_name]
      end
    end
  end
end
