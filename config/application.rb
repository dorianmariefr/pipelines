require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module Pipelines
  class Application < Rails::Application
    config.load_defaults 7.0
    config.generators.test_framework nil
    config.i18n.default_locale = :en
    config.i18n.available_locales = %i[en fr]
    config.action_mailer.default_url_options = { host: ENV.fetch("HOST") }
    config.assets.css_compressor = nil
    config.active_job.queue_adapter = :delayed_job

    config.after_initialize do |app|
      app.routes.default_url_options =
        app.config.action_mailer.default_url_options
    end

    if ENV["SESSION_REDIS_URL"]
      config.session_store :redis_session_store,
                           key: "_pipelines_session",
                           redis: {
                             url: ENV.fetch("SESSION_REDIS_URL"),
                             key_prefix: "pipelines:session:",
                             expire_after: 3.months
                           }
    end
  end
end
