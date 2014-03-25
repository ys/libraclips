require 'faraday'

module D2L
  module Librato
    class Client
      LIBRATO_URL = 'https://metrics-api.librato.com'
      METRICS_PATH = '/v1/metrics'

      def submit(metrics = { gauges: [] })
        client.post do |req|
          req.url METRICS_PATH
          req.headers['Content-Type'] = 'application/json'
          req.body =  metrics.to_json
        end
      end

      def client
        conn = Faraday.new(:url => LIBRATO_URL).tap do |conn|
          conn.basic_auth(librato_email, librato_token)
        end
      end

      def librato_email
        ENV['LIBRATO_EMAIL']
      end

      def librato_token
        ENV['LIBRATO_TOKEN']
      end
    end
  end
end
