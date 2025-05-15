json.extract! <%= singular_table_name %>, <%= attributes_names.map { |attr| ":#{attr}" }.join(", ") %>
json.url securial.<%= name.pluralize.downcase %>_url(<%= singular_table_name %>, format: :json)