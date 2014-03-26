module D2L
  module Config
    extend self

    def database_url
      ENV['DATABASE_URL'] || 'postgres://localhost:5432/dataclips2librato'
    end

    def poll_interval
      Integer(ENV['POLL_INTERVAL'] || 10)
    end

    def librato_email
      ENV['LIBRATO_EMAIL'] || raise(Config::Error, 'env key LIBRATO_EMAIL not set')
    end

    def librato_token
      ENV['LIBRATO_TOKEN'] || raise(Config::Error, 'env key LIBRATO_TOKEN not set')
    end

    def default_run_interval
      Integer(ENV['DEFAULT_RUN_INTERVAL'] || 60)
    end

    def default_librato_base_name
      ENV['DEFAULT_LIBRATO_BASE_NAME'] || 'default'
    end

    def basic_auth_username
      ENV['BASIC_AUTH_USERNAME'] || 'changeme'
    end

    def basic_auth_password
      ENV['BASIC_AUTH_PASSWORD'] || 'changeme'
    end

    class Error < StandardError; end
  end
end
