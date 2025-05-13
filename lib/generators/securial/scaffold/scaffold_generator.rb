require "rails/generators"
require "rails/generators/resource_helpers"
require "rails/generators/named_base"

module Securial
  module Generators
    class ScaffoldGenerator < Rails::Generators::NamedBase
      include Rails::Generators::ResourceHelpers

      source_root File.expand_path("templates", __dir__)

      argument :attributes, type: :array, default: [], banner: "field:type field:type"

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
        template(
          "controller.rb",
          File.join("app/controllers/securial", "#{controller_file_name}_controller.rb")
        )

        # Generate views
        Rails::Generators.invoke(
          "securial:jbuilder",
          [name, *attributes.map(&:to_s)],
          behavior: behavior,
          destination_root: Securial::Engine.root,
        )

        # Generate request specs
        template(
          "request_spec.rb",
          File.join("spec/requests/securial", "#{plural_table_name}_spec.rb")
        )

        # Generate routing specs
        template(
          "routing_spec.rb",
          File.join("spec/routing/securial", "#{plural_table_name}_routing_spec.rb")
        )
      end

      private

      def controller_class_name
        class_name.pluralize
      end

      def controller_file_name
        file_name.pluralize
      end

      def attributes_names
        attributes.map(&:name)
      end

      def orm_class
        Rails::Generators::ActiveModel
      end
    end
  end
end
