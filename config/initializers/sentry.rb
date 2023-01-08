Sentry.init do |config|
  config.dsn = Rails.application.credentials.sentry_dsn
  config.enabled_environments = ["production"]
end
