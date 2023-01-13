require "active_support/core_ext/integer/time"

Rails.application.configure do
  config.action_controller.perform_caching = true
  config.action_mailer.delivery_method = :ses
  config.action_mailer.perform_caching = true
  config.action_mailer.raise_delivery_errors = true
  config.active_record.dump_schema_after_migration = false
  config.active_storage.service = :local
  config.active_support.report_deprecations = false
  config.assets.compile = false
  config.cache_classes = true
  config.cache_store = :redis_cache_store, { url: ENV.fetch("CACHE_REDIS_URL") }
  config.consider_all_requests_local = false
  config.eager_load = true
  config.force_ssl = false
  config.i18n.fallbacks = true
  config.log_formatter = ::Logger::Formatter.new
  config.log_level = :info
  config.log_tags = [:request_id]
  config.public_file_server.enabled = ENV["RAILS_SERVE_STATIC_FILES"].present?
end
