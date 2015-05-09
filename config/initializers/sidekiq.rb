ENV["REDIS_PROVIDER"] ||= 'redis://localhost:6379/12'

# uri = URI.parse(ENV["REDISTOGO_URL"])
# REDIS = Redis.new(:url => uri)

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
  config.redis = { url: ENV["REDIS_PROVIDER"] }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV["REDIS_PROVIDER"] }
end