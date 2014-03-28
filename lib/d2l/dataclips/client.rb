require_relative 'result'
require_relative 'id_extractor'
require_relative '../metrics'
require 'benchmark'
require 'open-uri'
require 'json'

module D2L
  module Dataclips
    class Client
      # Fetch dataclip and returns a Dataclips::Result object
      # If an http error occurs, an empty object is returned
      # Accept dataclip url (with or without the .json) and also just the id.
      #
      def fetch(url_or_id)
        response = nil
        D2L::Metrics.track_time(:dataclips) do
          id = extract_dataclip_id(url_or_id)
          response = get(id)
        end
        response
      rescue OpenURI::HTTPError
        Dataclips::Result.new([], [])
      end

      private

      def get(id)
        response = http_get(id)
        Dataclips::Result.from(JSON.parse(response))
      end


      # Use open-uri for the moment as there is no special requirement here.
      def http_get(id)
        open(dataclip_url(id)) do |f|
          f.read
        end
      end

      def dataclip_url(id)
        "#{dataclips_url}#{id}#{dataclips_suffix}"
      end

      # Extract the id from the url
      # if just the id returns the id
      #
      def extract_dataclip_id(url)
        IdExtractor.new(url).call
      end

      def dataclips_url
        'https://dataclips.heroku.com/'.freeze
      end

      def dataclips_suffix
        '.json'.freeze
      end
    end
  end
end
