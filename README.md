# Securial

![Test Status](https://img.shields.io/badge/tests-passing-brightgreen)
![Coverage](https://img.shields.io/badge/coverage-100%25-success)
![License](https://img.shields.io/badge/license-MIT-blue)

**Securial** is a mountable Rails engine that provides robust, extensible authentication and access control for Rails applications. It supports:

- ✅ JWT-based authentication
- ✅ API tokens
- ✅ Session-based auth
- ✅ Simple integration with web and mobile apps
- ✅ Clean, JSON-based API responses

## Installation

### 1. Add the gem

Add this line to your Rails application's Gemfile:

```ruby
gem "securial"
```

### 2. Run the commands

Execute the following command:

```bash
$ bundle install
```

After installing the gem, run the generator:

```bash
$ rails generate securial:install
```

This will:

- Create an initializer at `config/initializers/securial.rb`
- Set up a log file at `log/securial.log`
- Copy the migration files to your host Rails application

### 3. Run the migrations:

Run the following command to migrate your database:

```bash
$ rails db:migrate
```

## Configuration

### 1. Configure the Engine

You can configure Securial in the generated initializer:

```ruby
# config/initializers/securial.rb
Securial.configure do |config|
  config.log_to_file = true # Enable/disable logging to file
  config.log_to_stdout = false # Enable/disable logging to stdout
  config.file_log_level = :info # Set log level for file logging
  config.stdout_log_level = :info # Set log level for stdout logging
  ...
end
```

## Usage

Once installed and mounted, you can access endpoints like:

- GET /securial/status – Check service availability
- GET /securial/admins/roles – View roles
- POST /securial/sessions – Sign in (JWT or session)
- DELETE /securial/sessions – Sign out

> TODO: add a link to the API endpoints from the wiki.

API responses are consistent and JSON-formatted:

```json
{
  "records": [
    {
      "id": 1,
      "email": "user@example.com",
      "created_at": "...",
      "updated_at": "...",
      "url": "/securial/admins/users/1"
    }
  ],
  "count": 42,
  "url": "/securial/admins/users"
}
```

## Development

To run tests:

```bash
$ bundle exec rspec
```

To see the coverage report:

```
$ open coverage/index.html
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/alybadawy/securial.

1. Fork the repo
2. Create your feature branch (git checkout -b my-feature)
3. Commit your changes (git commit -am 'Add my feature')
4. Push to the branch (git push origin my-feature)
5. Open a Pull Request

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
