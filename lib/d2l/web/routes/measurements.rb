module D2L
  module Web
    module Routes
      class Measurements < Sinatra::Application
        get '/measurements' do
          json measurements.all
        end

        post '/measurements' do
          begin
            params = JSON.parse(request.body.read)
            measurement = measurements.create(params)
            json measurement
          rescue Sequel::ValidationFailed => e
            halt 400, { error: e.message }.to_json
          end
        end

        patch '/measurements/:id' do
          begin
            measurement = measurements[params[:id]]
            measurement.update(JSON.parse(request.body.read))
            json measurement
          rescue Sequel::ValidationFailed => e
            halt 400, { error: e.message }.to_json
          end
        end

        def measurements
          D2L::Measurement
        end
      end
    end
  end
end
