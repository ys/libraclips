require 'sequel'
require 'scrolls'
require 'active_support/notifications'
require_relative 'config'

DB = Sequel.connect(D2L::Config.database_url)

ActiveSupport::Notifications.subscribe(/.*/) do |*args|
    event = ActiveSupport::Notifications::Event.new(*args)
    DB[:metrics].insert(name: event.name.to_s, duration: event.duration)
    Scrolls.log(event.payload.merge(duration: event.duration, name: event.name))
end
