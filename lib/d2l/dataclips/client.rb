require 'open-uri'
require 'json'
require_relative 'result'

module D2L
  module Dataclips
    class Client
      # Fetch dataclip and returns a Dataclips::Result object
      # If an http error occurs, an empty object is returned
      # Accept dataclip url (with or without the .json) and also just the id.
      #
      def fetch(url)
        id = extract_dataclip_id(url)
        response = get(id)
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
        open("https://dataclips.heroku.com/#{id}.json") do |f|
          f.read
        end
      end

      # Extract the id from the url
      # if just the id returns the id
      #
      def extract_dataclip_id(url)
        url.split("/").last.gsub(/\#.+/, '').gsub(/\.\w+/, '')
      end
    end
  end
end