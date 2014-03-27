module D2L
  module Web
    module Routes
      class Measurements < Sinatra::Application
        get '/measurements' do
          measurements.all.to_json
        end

        post '/measurements' do
          begin
            params = JSON.parse(request.body.read)
            measurement = measurements.create(params['dataclip_reference'],
                                              params['librato_base_name'],
                                              params['run_interval'])
            measurement.to_json
          rescue StandardError => e
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
