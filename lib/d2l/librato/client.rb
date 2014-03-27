require 'faraday'
require 'json'
require 'benchmark'

module D2L
  module Librato
    class Client
      attr_writer :client

      def submit(metrics = { gauges: [] })
        response = nil
        execution_time = Benchmark.realtime do
          response = client.post do |req|
            req.url Librato.metrics_path
            req.headers['Content-Type'] = 'application/json'
            req.body =  metrics.to_json
          end
          if response.status > 399
            raise Error.new(response.status, response.body)
          end
        end
        Scrolls.log(step: :push_metrics, duration: execution_time)
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

      def message
        body
      end
    end
  end
end
