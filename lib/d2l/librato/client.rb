require_relative '../config'
require 'faraday'

module D2L
  module Librato
    class Client

      def submit(metrics = { gauges: [] })
        client.post do |req|
          req.url librato_metrics_path
          req.headers['Content-Type'] = 'application/json'
          req.body =  metrics.to_json
        end
      end

      def client
        conn = Faraday.new(:url => librato_url).tap do |conn|
          conn.basic_auth(Config.librato_email, Config.librato_token)
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
