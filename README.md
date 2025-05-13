# Securial

Securial is a mountable Rails engine that provides robust, extensible authentication and access control for Rails applications. It supports JWT, API tokens, session-based auth, and is designed for easy integration with modern web and mobile apps.

## Usage

How to use Securial plugin.

## Installation

Add this line to your Rails application's Gemfile:

```ruby
gem "securial"
```

And then execute:

```bash
$ bundle
```

## Setup

### 1. Run the Installation Generator

After installing the gem, run the generator:

```bash
$ rails generate securial:install
```

This will:

- Create an initializer at `config/initializers/securial.rb`
- Set up a log file at `log/securial.log`

### 2. Configure the Engine

You can configure Securial in the generated initializer:

```ruby
# config/initializers/securial.rb
Securial.configure do |config|
  # Enable/disable logging to file
  config.log_to_file = true

  # Enable/disable logging to stdout
  config.log_to_stdout = false

  # Set log level for file logging (:debug, :info, :warn, :error, :fatal)
  config.file_log_level = :info

  # Set log level for stdout logging
  config.stdout_log_level = :info
end
```

## Contributing

Contribution directions go here.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
