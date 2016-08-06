require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Discursus
  class Application < Rails::Application
    config.i18n.available_locales = %i(uk en)
    config.i18n.default_locale = :uk
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    config.time_zone = 'Kyiv'
  end
end
