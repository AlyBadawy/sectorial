require "rails/generators"

module Securial
  module Generators
    class ScaffoldGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      argument :name, type: :string
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
      end

      private

      def controller_class_name
        name.classify.pluralize
      end

      def controller_file_name
        name.pluralize.underscore
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
