web: bundle exec puma -e $RAILS_ENV -C config/puma.rb
worker: bundle exec sidekiq -e production -q default -q mailers
