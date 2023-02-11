require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module Pipelines
  class Application < Rails::Application
    config.load_defaults 7.0
    config.generators.test_framework nil
    config.i18n.default_locale = :en
    config.i18n.available_locales = %i[en fr]
    config.action_mailer.default_url_options = {
      host: ENV.fetch("HOST", "localhost:3000"),
      protocol: ENV.fetch("PROTOCOL", "http")
    }
    config.asset_host = ENV.fetch("HOST", "localhost:3000")
    config.action_controller.default_url_options =
      config.action_mailer.default_url_options
    config.assets.css_compressor = nil
    config.active_job.queue_adapter = :sidekiq

    config.after_initialize do |app|
      app.routes.default_url_options =
        app.config.action_mailer.default_url_options
    end
  end
end
