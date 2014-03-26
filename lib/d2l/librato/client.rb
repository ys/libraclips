require_relative '../config'
require 'faraday'

module D2L
  module Librato
    class Client

      def submit(metrics = { gauges: [] })
        response = client.post do |req|
          req.url Librato.metrics_path
          req.headers['Content-Type'] = 'application/json'
          req.body =  metrics.to_json
        end
        if response.status > 399
          Scrolls.log(body:response.body, status: response.status)
        end
      end

      def client
        @client ||= Faraday.new(:url => Librato.url).tap do |conn|
          conn.basic_auth(Librato.email, Librato.token)
        end
      end

      def librato_url
        'https://metrics-api.librato.com'.freeze
      end

      def librato_metrics_path
        '/v1/metrics'.freeze
      end
    end
  end
end
