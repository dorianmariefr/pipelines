require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module Money
  class Application < Rails::Application
    config.load_defaults 7.0
    config.generators.test_framework nil
    config.i18n.default_locale = :en
    config.i18n.available_locales = %i[en fr]
    config.action_mailer.default_url_options = { host: ENV.fetch("HOST") }
  end
end
