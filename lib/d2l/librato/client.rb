require 'faraday'
require 'json'

module D2L
  module Librato
    class Client
      attr_writer :client

      def submit(metrics = { gauges: [] })
        response = client.post do |req|
          req.url Librato.metrics_path
          req.headers['Content-Type'] = 'application/json'
          req.body =  metrics.to_json
        end
        if response.status > 399
          Scrolls.log(body:response.body, status: response.status)
          raise Error.new(response.status, response.body)
        end
        response
      end

      private

      def client
        @client ||= Faraday.new(:url => Librato.url).tap do |conn|
          conn.basic_auth(Librato.email, Librato.token)
        end
      end
    end

    class Error < StandardError
      attr_reader :status, :body
      def initialize(status, body = '')
        @status = status
        @body   = body
      end

      def parsed_body
        @parsed_body ||= JSON.parse(body)
      end
    end
  end
end
