source "https://rubygems.org"

# Specify your gem's dependencies in securial.gemspec.
gemspec

gem "propshaft"
gem "puma"
gem "sqlite3"

group :development do
  gem "fasterer"
  gem "overcommit"
  gem "rubocop", require: false
  gem "rubocop-config-prettier", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rails-omakase", require: false
  gem "rubocop-rspec", require: false
end

group :development, :test do
  gem "brakeman", require: false
  gem "capybara"
  gem "coveralls-lcov", require: false
  gem "database_cleaner"
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "dotenv-rails"
  gem "factory_bot_rails"
  gem "faker"
  gem "generator_spec"
  gem "ostruct"
  gem "pry-byebug"
  gem "pry-rails"
  gem "rspec-rails"
  gem "shoulda-matchers"
  gem "simplecov"
  gem "simplecov-lcov", "~> 0.8.0"
end
