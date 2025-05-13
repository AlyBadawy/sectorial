# lib/generators/securial/scaffold/scaffold_generator.rb
require "rails/generators"

module Securial
  module Generators
    class ScaffoldGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      argument :name, type: :string
      argument :attributes, type: :array, default: [], banner: "field:type field:type"

      def run_scaffold
        say_status("info", "Running built-in scaffold generator with custom options", :blue)

        Rails::Generators.invoke(
          "scaffold",
          [name, *attributes.map(&:to_s), "--api=false", "--template-engine=jbuilder"],
          behavior: behavior,
          destination_root: Rails.root,
        )
      end
    end
  end
end
