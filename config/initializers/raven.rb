if Rails.application.secrets.sentry_dsn
  require "raven"

  Raven.configure do |config|
    config.dsn = Rails.application.secrets.sentry_dsn
  end
end
