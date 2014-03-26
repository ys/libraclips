require 'rubygems'
require 'bundler'

Bundler.require

require 'dotenv'
Dotenv.load

require 'sinatra/base'
require_relative '../../d2l'
require_relative 'routes'

module D2L
  module Web
    class App < Sinatra::Application

      use Rack::Auth::Basic, "Restricted Area" do |username, password|
          username == D2L::Config.basic_auth_username and password == D2L::Config.basic_auth_password
      end

      use Routes::Home
      use Routes::Measurements
    end
  end
end
