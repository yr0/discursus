source 'https://rubygems.org'

ruby '2.3.1'

# use postgres as DB
gem 'pg', '~> 0.18'

gem 'rails', '~> 5.0.0'
gem 'puma', '~> 3.0'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails', '~> 4.2'
gem 'jquery-ui-rails', '~> 6.0'
gem 'turbolinks', '~> 5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# use rspec for testing
gem 'rspec-rails'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'slim-rails', '~> 3.1'
gem 'bootstrap-sass', '~> 3.3'
gem 'font-awesome-rails', '~> 4.6'
gem 'autoprefixer-rails', '~> 6.4'
gem 'simple_form', '~> 3.2'
# nested model forms
gem 'cocoon', '~> 1.2'
# pagination
gem 'kaminari', '~> 0.17'
# ajax flash notifications
gem 'gritter', '~> 1.2'
# uploads
gem 'carrierwave', '~> 0.11'
gem 'mini_magick', '~> 4.5'
# rich text editor
gem 'ckeditor', '~> 4.2'
# ordering records
gem 'acts_as_list', '~> 0.8'
# tagging
gem 'acts-as-taggable-on', '~> 4.0'
# full text search with apache solr
gem 'sunspot_rails'
# finite state machines
gem 'aasm'
# liqpay API wrapper
gem 'liqpay', github: 'yr0/liqpay'
# Mailgun wrapper for rails
gem 'mailgun_rails'

# friendly urls
gem 'friendly_id', '~> 5.1'
gem 'babosa', '~> 1.0'
gem 'unicode', '~> 0.4'

# async jobs
gem 'sidekiq'
# Namespaced redis instances
gem 'redis-namespace'

# auth
gem 'devise', '~> 4.2'
gem 'cancancan', '~> 1.15'
gem 'recaptcha', '~> 4.1', require: 'recaptcha/rails'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'

# env load and process control
gem 'dotenv', '~> 2.1'
gem 'dotenv-rails', '~> 2.1'
gem 'foreman'

group :test do
  gem 'sunspot_test'
  gem 'database_cleaner'
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
  gem 'rubocop'
  gem 'capistrano-rails'
end
