source 'https://rubygems.org'

ruby '2.7.2'

# use postgres as DB
gem 'pg', '~> 0.18'

gem 'rails', '~> 5.2.6'
gem 'puma', '~> 4.3'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails', '~> 4.2'
gem 'jquery-ui-rails', '~> 6.0'
gem 'turbolinks'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'slim-rails', '~> 3.1'
gem 'bootstrap-sass', '~> 3.4'
gem 'font-awesome-rails', '~> 4.7'
gem 'autoprefixer-rails', '~> 6.4'
gem 'simple_form', '~> 5.0'
# nested model forms
gem 'cocoon', '~> 1.2'
# pagination
gem 'kaminari', '~> 1.2'
# ajax flash notifications
gem 'gritter', '~> 1.2'
# uploads
gem 'carrierwave', '~> 1.3.2'
gem 'mini_magick', '~> 4.9'
# rich text editor
gem 'ckeditor', '~> 5.1'
# ordering records
gem 'acts_as_list', '~> 0.8'
# tagging
gem 'acts-as-taggable-on'
# full text search with apache solr
gem 'sunspot_rails', '~> 2.3.0'
# finite state machines
gem 'aasm'
# Mailgun wrapper for rails
gem 'mailgun-ruby', '~>1.1.6'

gem 'rack', '>= 2.0.6'
gem 'loofah', '>= 2.2.3'
gem 'ffi', '>= 1.9.24'
gem 'rack-protection', '>= 1.5.5'

# friendly urls
gem 'friendly_id', '~> 5.1'
gem 'babosa', '~> 1.0'
gem 'unicode', '~> 0.4'

# async jobs
gem 'sidekiq'
# Namespaced redis instances
gem 'redis-namespace'

# auth
gem 'devise', '~> 4.8'
gem 'cancancan', '~> 1.15'
gem 'recaptcha', '~> 5.8', require: 'recaptcha/rails'
gem 'omniauth', '~> 1'
gem 'omniauth-facebook', '4.0.0'
gem 'omniauth-google-oauth2', '0.8.2'
gem 'omniauth-rails_csrf_protection'

# env load and process control
gem 'dotenv', '~> 2.7'
gem 'dotenv-rails', '~> 2.7'
gem 'foreman'

# use Sentry for tracking errors
gem 'sentry-raven'

gem 'whenever', require: false

group :test do
  gem 'rspec-rails'

  gem 'sunspot_test'
  gem 'database_cleaner-active_record'
  gem 'db-query-matchers'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'factory_girl_rails'
  gem 'faker'
end

group :development do
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'rubocop', '~> 0.86.0'
  gem 'rubocop-rails', '~> 2.6'
  gem 'capistrano', '3.6.1'
  gem 'capistrano-rails'
  gem 'capistrano-rvm'
  gem 'net-ssh', '~> 5.1.0'
end
