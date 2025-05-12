module Securial
  class Engine < ::Rails::Engine
    isolate_namespace Securial
    config.generators.api_only = true

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
    end
  end
end
