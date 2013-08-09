Sidekiq.configure_server do |config|
  config.redis = { url: ENV["REDISCLOUD_URL"], namespace: ENV["REDIS_NAMESPACE"]  }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV["REDISCLOUD_URL"], namespace: ENV["REDIS_NAMESPACE"], size: 1 }
end
