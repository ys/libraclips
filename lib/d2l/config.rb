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
      ENV['LIBRATO_EMAIL']
    end

    def librato_token
      ENV['LIBRATO_TOKEN']
    end

  end
end
