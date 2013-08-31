require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Ocarina
  class Application < Rails::Application

    config.assets.enabled = true
    config.assets.paths << "#{Rails.root}/app/assets/fonts"
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.assets.precompile += %w(*.png *.jpg *jpeg *.gif)

    config.autoload_paths += %W( #{config.root}/lib )

    config.cache_store          = :redis_store, ENV["REDISCLOUD_URL"] || "redis://127.0.0.1:6379/0/ocarina"
    config.identity_cache_store = :redis_store, ENV["REDISCLOUD_URL"] || "redis://127.0.0.1:6379/0/ocarina"

    # Mailer options
    config.action_mailer.delivery_method     = :smtp
    config.action_mailer.default_url_options = { :host => ENV['HOST'] }
    config.action_mailer.smtp_settings = {
      address:              'smtp.gmail.com',
      port:                 587,
      domain:               'gmail.com',
      user_name:            ENV['SMTP_USER_NAME'],
      password:             ENV['SMTP_PASSWORD'],
      authentication:       'plain',
      enable_starttls_auto: true  }

  end
end
