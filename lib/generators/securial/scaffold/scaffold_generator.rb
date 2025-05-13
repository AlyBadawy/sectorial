require "rails/generators"
require "rails/generators/resource_helpers"
require "rails/generators/named_base"

module Securial
  module Generators
    class ScaffoldGenerator < Rails::Generators::NamedBase
      include Rails::Generators::ResourceHelpers

      source_root File.expand_path("templates", __dir__)

      # Add ORM class option
      class_option :orm, type: :string, default: "active_record"

      argument :attributes, type: :array, default: [], banner: "field:type field:type"

      def self.file_name
        "generator_manifest.txt"
      end

      def run_scaffold
        say_status("info", "Running built-in scaffold generator with custom options", :blue) unless Rails.env.test?

        # Generate model and migration
        Rails::Generators.invoke(
          "model",
          [name, *attributes.map(&:to_s)],
          behavior: behavior,
          destination_root: Securial::Engine.root,
        )

        # Generate controller from template
        @controller_path = File.join("app/controllers/securial", "#{controller_file_name}_controller.rb")
        template("controller.rb", @controller_path)

        # Generate views
        Rails::Generators.invoke(
          "securial:jbuilder",
          [name, *attributes.map(&:to_s)],
          behavior: behavior,
          destination_root: Securial::Engine.root,
        )

        # Generate request specs
        @request_spec_path = File.join("spec/requests/securial", "#{resource_path_name}_spec.rb")
        template("request_spec.rb", @request_spec_path)

        # Generate routing specs
        @routing_spec_path = File.join("spec/routing/securial", "#{resource_path_name}_routing_spec.rb")
        template("routing_spec.rb", @routing_spec_path)
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

      def model_name
        "Securial::#{class_name}"
      end

      def controller_class_name
        class_name.pluralize
      end

      def controller_file_name
        plain_plural_name
      end
    end
  end
end
