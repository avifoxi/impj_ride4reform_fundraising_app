# ENV["REDIS_PROVIDER"] ||= 'redis://localhost:6379/12'

ENV["REDISTOGO_URL"] ||= 'redis://localhost:6379/12'

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

# Sidekiq.configure_server do |config|
#   config.redis = { url: ENV["REDIS_PROVIDER"] }
# end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV["REDISTOGO_URL"] }
end

Sidekiq.configure_server do |config|
  config.redis = { url: ENV["REDISTOGO_URL"] }

  # database_url = ENV['DATABASE_URL']
  # if database_url
  #   ENV['DATABASE_URL'] = "#{database_url}?pool=25"
  #   ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])
  #   # Note that as of Rails 4.1 the `establish_connection` method requires
  #   # the database_url be passed in as an argument. Like this:
  #   # ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])
  # end
end