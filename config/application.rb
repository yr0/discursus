# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Discursus
  class Application < Rails::Application
    config.load_defaults 5.2

    config.i18n.available_locales = %i(uk en)
    config.i18n.default_locale = :uk
    config.i18n.fallbacks = [:en]
    config.i18n.load_path += Dir[Rails.root.join('config/locales/**/*.{rb,yml}')]
    config.time_zone = 'Kyiv'
    config.action_view.embed_authenticity_token_in_remote_forms = true
    config.default_currency = :uah
    config.active_job.queue_adapter = :sidekiq

    config.admin_email = ENV['ADMIN_EMAIL']
    Rails.application.routes.default_url_options[:host] = ENV['DISCURSUS_HOST']
    config.disable_recaptcha = ENV['DISABLE_RECAPTCHA'].present?

    config.eager_load_paths << Rails.root.join('lib')
  end
end
