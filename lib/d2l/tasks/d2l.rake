require 'dotenv/tasks'

namespace :d2l do
  desc "Run poller"
  task poll: [:environment, :dotenv] do
    D2L.run
  end
end

task :environment do
  require_relative "../../d2l"
end
