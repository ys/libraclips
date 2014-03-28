require 'active_support/notifications'

module D2L
  module Metrics
    def self.track_time(metric_name, payload = {}, &block)
      ActiveSupport::Notifications.instrument(metric_name, payload, &block)
    end
  end
end
