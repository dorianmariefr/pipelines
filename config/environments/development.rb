require "active_support/core_ext/integer/time"

Rails.application.configure do
  config.action_controller.perform_caching = true
  config.action_mailer.delivery_method = :letter_opener
  config.action_mailer.perform_caching = true
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = false
  config.action_view.annotate_rendered_view_with_filenames = true
  config.active_record.migration_error = :page_load
  config.active_record.verbose_query_logs = true
  config.active_storage.service = :amazon
  config.active_storage.service = :local
  config.active_support.deprecation = :log
  config.active_support.disallowed_deprecation = :raise
  config.active_support.disallowed_deprecation_warnings = []
  config.assets.quiet = true
  config.cache_classes = false
  config.cache_store = :redis_cache_store, { url: ENV.fetch("REDIS_URL") }
  config.consider_all_requests_local = true
  config.eager_load = false
  config.hosts << "dev.pipelines.plumbing"
  config.i18n.raise_on_missing_translations = true
  config.server_timing = true
  config.i18n.exception_handler =
    proc { |exception| raise exception.to_exception }
end
