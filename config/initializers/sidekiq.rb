ENV["REDIS_URL"] ||= 'redis://localhost:6379/12'

# Sidekiq.configure_server do |config|
#   config.redis = { url: ENV["REDIS_URL"], namespace: 'sidekiq' }
# end

# unless Rails.env.production?
#   Sidekiq.configure_client do |config|
#     config.redis = { url: ENV["REDIS_URL"], namespace: 'sidekiq'  }
#   end
# end

# Sidekiq.configure_server do |config|
#   config.redis = { url: 'redis://redis.example.com:6379/12' }
# end

# Sidekiq.configure_client do |config|
#   config.redis = { url: 'redis://redis.example.com:6379/12' }
# end

Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://localhost:6379/12' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://localhost:6379/12' }
end