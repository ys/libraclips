module D2L
  module Web
    module Routes
      class Home < Sinatra::Application
        get '/' do
          { measurements: '/measurements' }.to_json
        end
      end
    end
  end
end

