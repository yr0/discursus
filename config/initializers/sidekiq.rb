# frozen_string_literal: true

# Sidekiq will connect to redis socket in namespace of DB_NAME, which is unique for every environment
redis_url = ENV['REDIS_URL'] || 'redis://localhost:6379/0'
namespace = ENV['DATABASE_NAME'] || 'discursus_production'

Sidekiq.configure_server do |config|
  config.redis = Sidekiq::RedisConnection.create(url: redis_url, namespace: namespace)
end

Sidekiq.configure_client do |config|
  config.redis = Sidekiq::RedisConnection.create(url: redis_url, namespace: namespace)
end
