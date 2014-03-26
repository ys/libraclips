require 'test_helper'

class D2L::ConfigTest < Minitest::Unit::TestCase
  def swap_env!(key, value)
    @env_store ||= {}
    @env_store[key.to_s.upcase] ||= ENV[key.to_s.upcase]
    ENV[key.to_s.upcase] = value.to_s
  end

  def remove_key!(key)
    @env_store ||= {}
    @env_store[key.to_s.upcase] ||= ENV[key.to_s.upcase]
    ENV[key.to_s.upcase] = nil
  end

  def reset_env(key)
    ENV[key.to_s.upcase] = @env_store.fetch(key.to_s.upcase)
  end

  {
    database_url: 'url',
    poll_interval: 100,
    default_run_interval: 100,
    librato_email: 'email',
    librato_token: 'token'
  }.each do |config_key, value|
    define_method("test_#{config_key}_env") do
      swap_env!(config_key, value)
      assert_equal D2L::Config.send(config_key), value
      reset_env(config_key)
    end
  end

  {
    database_url: 'postgres://localhost:5432/dataclips2librato',
    poll_interval: 10,
    default_run_interval: 60
  }.each do |config_key, default|
    define_method("test_#{config_key}_url_default") do
      remove_key!(config_key)
      assert_equal D2L::Config.send(config_key), default
      reset_env(config_key)
    end
  end

  %w{librato_email librato_token}.each do |config_key|
    define_method("test_#{config_key}_env_is_mandatory") do
      remove_key!(config_key)
      assert_raises D2L::Config::Error do
        D2L::Config.send(config_key)
      end
      reset_env(config_key)
    end
  end
end
