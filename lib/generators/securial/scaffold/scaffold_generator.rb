require "rails/generators"
require "rails/generators/resource_helpers"
require "rails/generators/named_base"

module Securial
  module Generators
    class ScaffoldGenerator < Rails::Generators::NamedBase
      include Rails::Generators::ResourceHelpers

      # Enable incompatible default types for Thor options
      self.allow_incompatible_default_type! if Rails.env.test?

      Thor::Base.shell = Thor::Shell::Color

      source_root File.expand_path("templates", __dir__)

      class_option :orm,
                   type: :string,
                   default: "active_record",
                   desc: "ORM to use (defaults to active_record)",
                   banner: "NAME"

      argument :attributes, type: :array, default: [], banner: "field:type field:type"

      def self.file_name
        "generator_manifest.txt"
      end

      def run_scaffold # rubocop:disable Metrics/MethodLength
        say_status(:scaffold, "Running built-in scaffold generator with custom options", :cyan) unless Rails.env.test?

        # Generate model and migration
        Rails::Generators.invoke(
          "model",
          [name, *attributes.map(&:to_s)],
          behavior: behavior,
          destination_root: root_path,
        )

        indent = "  " # two-space indent

        # Generate controller from template
        say_status(:scaffold, "controller", :cyan) unless Rails.env.test?
        say_status(status_behavior, "#{indent}#{controller_path}", status_color) unless Rails.env.test?
        template("controller.rb", controller_path, verbose: false)

        # Generate views
        say_status(:scaffold, "JBuilder views", :cyan) unless Rails.env.test?
        Rails::Generators.invoke(
          "securial:jbuilder",
          [name, *attributes.map(&:to_s)],
          behavior: behavior,
          destination_root: Securial::Engine.root,
        )

        say_status(:scaffold, "controller specs: #{@routing_spec_path}", :cyan) unless Rails.env.test?

        # Generate request specs
        say_status(status_behavior, "#{indent}#{request_spec_path}", status_color) unless Rails.env.test?
        template("request_spec.rb", request_spec_path, verbose: false)

        # Generate routing specs
        say_status(status_behavior, "#{indent}#{routing_spec_path}", status_color) unless Rails.env.test?
        template("routing_spec.rb", routing_spec_path, verbose: false)

        say_status(:success, "Scaffold complete ✨✨", :green) unless Rails.env.test?
      end

      private

      def namespaced_name
        @namespaced_name ||= "securial_#{name.underscore}"
      end

      def plain_plural_name
        @plain_plural_name ||= name.underscore.pluralize
      end

      def resource_path_name
        plain_plural_name
      end

      def table_name
        @table_name ||= namespaced_name.pluralize
      end

      def controller_class_name
        class_name.pluralize
      end

      def controller_file_name
        plain_plural_name
      end

      def status_behavior
        behavior == :invoke ? :create : :remove
      end

      def status_color
        behavior == :invoke ? :green : :red
      end

      def controller_path
        base_path = Rails.env.test? ? Rails.root.join("tmp/app/controllers/securial").to_s : "app/controllers/securial"
        @controller_path ||= File.join(base_path, "#{controller_file_name}_controller.rb")
      end

      def request_spec_path
        base_path = Rails.env.test? ? Rails.root.join("tmp/spec/requests/securial").to_s : "spec/requests/securial"
        @request_spec_path ||= File.join(base_path, "#{resource_path_name}_spec.rb")
      end

      def routing_spec_path
        base_path = Rails.env.test? ? Rails.root.join("tmp/spec/routing/securial").to_s : "spec/routing/securial"
        @routing_spec_path ||= File.join(base_path, "#{resource_path_name}_routing_spec.rb")
      end

      def root_path
        Rails.env.test? ? Rails.root.join("tmp/") : Engine.root
      end
    end
  end
end
