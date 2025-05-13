require "rails/generators"

module Securial
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      desc "Creates a Securial initializer in your application."

      def copy_initializer
        template "securial_initializer.rb", "config/initializers/securial.rb"
      end

      def create_log_file
        log_dir = Rails.root.join("log")
        securial_log = log_dir.join("securial.log")

        FileUtils.mkdir_p(log_dir) unless File.directory?(log_dir)

        say_status("create", "log/securial.log")
        FileUtils.touch(securial_log)
      end
    end
  end
end
