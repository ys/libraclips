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
      use Routes::Home
      use Routes::Measurements
    end
  end
end
