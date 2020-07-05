# frozen_string_literal: true

Raven.configure do |config|
  config.dsn = ENV['SENTRY_DSN']
  config.sanitize_fields =
    Rails.application.config.filter_parameters.map(&:to_s) + %w(email phone full_name city street)
end
