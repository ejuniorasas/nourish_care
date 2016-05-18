source 'https://rubygems.org'

gem 'rails', '4.2.6'

gem 'rails-api'

gem 'spring', group: :development

gem 'mongoid', '~> 5.1.0'
gem 'rspec', '~> 3.4'

# C extensions to accelerate the Ruby BSON serialization
gem 'bson_ext'
# Serializer used to fix mongod ID return
gem 'active_model_serializers', '~> 0.9.0'
# Provides enum-like fields for ActiveRecord, ActiveModel and Mongoid models
gem 'simple_enum', '~> 2.0.0', require: 'simple_enum/mongoid'
# Factory feature of fixture objects
gem 'factory_girl_rails'
# ApiPie - shows the API Docs
# https://github.com/Apipie/apipie-rails
gem 'apipie-rails'

group :development, :test, :ci do
  #
  # Quality
  #####
  # Rails rspec with bunch of helpers
  gem 'rspec-rails'
  # Clear data to ensure the test without memory
  gem 'database_cleaner', git: 'https://github.com/DatabaseCleaner/database_cleaner.git'
  # Gem to ensure the test coverage
  gem 'simplecov-rcov', require: false
  # helpers to test models and controllers
  gem 'shoulda-matchers'
  # helpers to test models in the mongo context
  gem 'mongoid-rspec'
  # Allows xml reports for rspec
  gem 'ci_reporter_rspec', require: false
  # Ruby static code analyzer
  gem 'rubocop', require: false

  #
  # Environment support
  #####
  # Add behavior of reload the code in the server, this will consume more
  # resource so keep only in the dev environment
  gem 'spring'
  # Console with asteroids
  gem 'pry'
  # Debug feature, to use put in the line you want to have a break point:
  # `binding.pry`
  gem 'pry-byebug'
end
