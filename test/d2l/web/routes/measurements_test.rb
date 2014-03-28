require 'test_helper'
require 'rack/test'

class D2L::Web::Routes::MeasurementsTest < Minitest::Unit::TestCase
  include Rack::Test::Methods

  def app
    D2L::Web::App.new
  end

  def last_json
    JSON.parse last_response.body
  end

  def setup
    authorize D2L::Config.basic_auth_username, D2L::Config.basic_auth_password
  end

  def test_get_measurements_returns_a_200
    get '/measurements'
    assert_equal last_response.status, 200
  end

  def test_get_measurements
    DB.transaction(rollback: :always) do
      measurement = D2L::Measurement.create(dataclip_reference: 'ref', librato_base_name: 'default')
      get '/measurements'
      assert_equal last_json.size, 1
      json_measurement = last_json[0]
      assert json_measurement.has_key? 'id'
      assert json_measurement.has_key? 'dataclip_reference'
      assert json_measurement.has_key? 'librato_base_name'
      assert json_measurement.has_key? 'run_at'
      assert json_measurement.has_key? 'run_interval'
    end
  end

  def test_post_measurements
    DB.transaction(rollback: :always) do
      measurement = D2L::Measurement.new(dataclip_reference: 'ref', librato_base_name: 'default')
      post '/measurements', measurement.to_json, "CONTENT_TYPE" => "application/json"
      assert_equal last_response.status, 200
      assert_equal D2L::Measurement.count, 1
      assert_equal last_json['dataclip_reference'], 'ref'
      assert_equal last_json['librato_base_name'], 'default'
    end
  end

  def test_patch_measurements
    DB.transaction(rollback: :always) do
      measurement = D2L::Measurement.create(dataclip_reference: 'ref', librato_base_name: 'default')
      patch "/measurements/#{measurement.id}", { run_interval: 10, dataclip_reference: 'WAT' }.to_json, "CONTENT_TYPE" => "application/json"
      assert_equal last_response.status, 200
      assert_equal last_json['dataclip_reference'], 'WAT'
      assert_equal last_json['run_interval'], 10
    end
  end

  def test_post_invalid_measurements
    DB.transaction(rollback: :always) do
      measurement = D2L::Measurement.new(librato_base_name: 'default')
      post '/measurements', measurement.to_json, "CONTENT_TYPE" => "application/json"
      assert_equal last_response.status, 400
      assert_equal D2L::Measurement.count, 0
      assert_equal last_json['error'], 'dataclip_reference is not present'
    end
  end

  def test_patch_invalid_measurements
    DB.transaction(rollback: :always) do
      measurement = D2L::Measurement.create(dataclip_reference: 'ref', librato_base_name: 'default')
      patch "/measurements/#{measurement.id}", { run_interval: 10, dataclip_reference: '' }.to_json, "CONTENT_TYPE" => "application/json"
      assert_equal last_response.status, 400
      assert_equal last_json['error'], 'dataclip_reference is not present'
    end
  end

end
