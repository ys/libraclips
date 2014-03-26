require_relative 'librato/client'
require_relative 'config'

module D2L
  module Librato
    extend self

    def email
      Config.librato_email
    end

    def token
      Config.librato_token
    end

    def url
      'https://metrics-api.librato.com'.freeze
    end

    def metrics_path
      '/v1/metrics'.freeze
    end
  end
end
