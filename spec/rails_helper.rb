ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
require 'sidekiq/testing'

# require all files from 'support'
Dir[Rails.root.join('spec/support/**/*.rb')].sort.each { |f| require f }
# Checks for pending migration and applies them before tests are run.
ActiveRecord::Migration.maintain_test_schema!
Sidekiq::Testing.fake!

RSpec.configure do |config|
  include FactoryGirl::Syntax::Methods
  include ::ControllerHelpers

  config.include Devise::Test::ControllerHelpers, type: :controller
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.filter_run_excluding search: true

  Sunspot.session = Sunspot::Rails::StubSessionProxy.new(Sunspot.session)

  config.after(:each) { ActionMailer::Base.deliveries.clear }

  config.before(:suite) do
    FactoryGirl.lint
    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner.strategy = :transaction
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  config.around(:each, search: true) do |example|
    Sunspot.remove_all!
    example.run
    Sunspot.remove_all!
  end
end
