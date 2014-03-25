module D2L
  module Dataclips
    class IdExtractor
      def initialize(url_or_id)
        @url_or_id = url_or_id
      end

      def call
        @url_or_id.split("/").last.gsub(/\#.+/, '').gsub(/\.\w+/, '')
      end
    end
  end
end
