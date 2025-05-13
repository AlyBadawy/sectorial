require "simplecov"

SimpleCov.start do
  add_filter "/spec/"
  add_filter "/lib/securial/version.rb"
  add_filter "/lib/generators/securial/install/templates/"
  add_filter "/lib/generators/securial/scaffold/templates/"

  track_files "lib/**/*.rb"
  minimum_coverage (ENV.fetch("SIMPLECOV_MINIMUM_COVERAGE") { 95 }).to_i
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
