require_relative "lib/securial/version"

Gem::Specification.new do |spec|
  spec.name = "securial"
  spec.version = Securial::VERSION
  spec.authors = ["Aly Badawy"]
  spec.email = ["1198568+AlyBadawy@users.noreply.github.com"]
  spec.homepage = "https://github.com/AlyBadawy/Securial"
  spec.summary = "Authentication and access control Rails engine for your API."
  spec.description = "Securial is a mountable Rails engine that provides robust, extensible authentication and access control for Rails applications. It supports JWT, API tokens, session-based auth, and is designed for easy integration with modern web and mobile apps."
  spec.license = "MIT"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/AlyBadawy/Securial"
  spec.metadata["changelog_uri"] = "https://github.com/AlyBadawy/Securial/blob/main/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.required_ruby_version = ">= 3.4.1"
  spec.add_runtime_dependency "rails", "~> 8.0", ">= 8.0.2"

  spec.add_dependency "jbuilder", "~> 2.11"

  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "rubocop-rspec"
  spec.add_development_dependency "factory_bot_rails"
end
