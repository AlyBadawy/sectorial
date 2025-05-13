require_relative "../securial/logger"
require_relative "../securial/middleware/request_logger_tag"

module Securial
  class Engine < ::Rails::Engine
    isolate_namespace Securial
    config.generators.api_only = true

    config.autoload_paths += Dir["#{config.root}/lib/generators"]

    config.generators do |g|
      g.test_framework :rspec,
                       fixtures: false,
                       view_specs: false,
                       helper_specs: false,
                       routing_specs: true,
                       controller_specs: true,
                       request_specs: true,
                       model_specs: true

      g.fixture_replacement :factory_bot, dir: "spec/factories"

      # Add JBuilder configuration
      g.template_engine :jbuilder
    end

    initializer "securial.logger" do
      Securial.const_set(:ENGINE_LOGGER, Securial::Logger.build)
    end

    initializer "securial.middleware" do |app|
      app.middleware.use Securial::Middleware::RequestLoggerTag
    end
  end
end
