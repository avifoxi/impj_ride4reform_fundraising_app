source 'http://rubygems.org'
ruby '2.2.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.5'
# Use postgresql as the database for Active Record
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

gem 'devise'

gem 'rails_12factor', group: :production

# Use unicorn as the app server
# gem 'unicorn'

# why not ? 

gem "therubyracer"
gem "less-rails" #Sprockets (what Rails 3.1 uses for its asset pipeline) supports LESS
gem "twitter-bootstrap-rails"
# gem 'jquery-ui-rails'

gem "font-awesome-rails"

gem 'bootstrap-datepicker-rails'

# another plataformatec gem, ala devise
gem 'simple_form', '~> 3.1.0'

# Paypal SDK
gem 'paypal-sdk-rest'

# Amazon SDK
gem 'aws-sdk-v1'

# Paperclip for file upload
gem "paperclip", "~> 4.2"

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# for location, zip / state comparison
gem 'area'

gem 'faker'

# moving factory girl to here for seed in staging -- ensure the addies are gonna pass the area gem's zip validation against state + city
gem "factory_girl_rails", "~> 4.0"
# Use debugger

group :development, :test do
  gem 'rspec-rails', '~> 3.0'
  gem 'database_cleaner', '~> 1.4.0'
  gem 'byebug'
  gem 'dotenv-rails'
end

gem 'simplecov', '~> 0.9.0', :require => false, :group => :test

group :test do 
	gem 'webmock'
  gem 'vcr', '~> 2.9.3'
end


