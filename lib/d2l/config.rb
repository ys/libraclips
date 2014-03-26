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

    class Error < StandardError; end
  end
end
