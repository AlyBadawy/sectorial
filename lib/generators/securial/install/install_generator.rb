require "rails/generators"
require "rake"

module Securial
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      desc "initializes Securial in your application."

      def copy_initializer
        say_status("copying", "Securial Initializers", :green)
        template "securial_initializer.rb", "config/initializers/securial.rb"
      end

      def create_log_file
        say_status("creating", "Securial Log file", :green)
        log_dir = Rails.root.join("log")
        securial_log = log_dir.join("securial.log")

        FileUtils.mkdir_p(log_dir) unless File.directory?(log_dir)
        FileUtils.touch(securial_log) unless File.exist?(securial_log)
      end

      def install_migrations
        return if Rails.root.to_s.include?("spec/dummy") ||
                  Rails.root.to_s.include?("tmp") ||
                  Rails.env.test?

        say_status("copying", "Securial migrations", :green)
        load_tasks
        Rake::Task["securial:install:migrations"].invoke
      end

      private

      def load_tasks
        Rails.application.load_tasks unless Rake::Task.task_defined?("securial:install:migrations")
      end
    end
  end
end
