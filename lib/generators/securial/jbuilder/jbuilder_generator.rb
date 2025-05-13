module Securial
  module Generators
    class JbuilderGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("templates", __dir__)

      argument :attributes, type: :array, default: [], banner: "field:type field:type"

      def create_view_files
        template "_resource.json.jbuilder", File.join("app/views/securial", plural_table_name, "_#{singular_table_name}.json.jbuilder")
        template "index.json.jbuilder", File.join("app/views/securial", plural_table_name, "index.json.jbuilder")
        template "show.json.jbuilder", File.join("app/views/securial", plural_table_name, "show.json.jbuilder")
      end

      private

      def attributes_names
        attributes.map { |attr| attr.name }
      end
    end
  end
end
