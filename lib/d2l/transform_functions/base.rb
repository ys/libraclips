module D2L
  module TransformFunctions
    class Base

      attr_reader :dataclip, :measurement

      def accepts?(dataclip)
        raise 'You need to redefine that method on your inherited class'
      end

      def transform
        raise 'You need to redefine that method on your inherited class'
      end

      def call(dataclip, measurement)
        @dataclip = dataclip
        @measurement = measurement
        apply_source_to_metrics(transform)
      end

      def apply_source_to_metrics(response)
        if measurement.librato_source
          response[:gauges].each do |metric|
            metric[:source] = measurement.librato_source
          end
        end
        response
      end
    end
  end
end
