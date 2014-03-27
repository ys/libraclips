module D2L
  module Dataclips
    class IdExtractor
      def initialize(url_or_id)
        @url_or_id = url_or_id
      end

      def call
        path = @url_or_id.split("/").last
        if path
          path.gsub(/\#.+/, '').gsub(/\.\w+/, '')
        else
          nil
        end
      end
    end
  end
end
