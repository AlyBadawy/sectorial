json.extract! <%= singular_table_name %>, <%= attributes_names.map { |attr| ":#{attr}" }.join(", ") %>
json.url <%= singular_table_name %>_url(<%= singular_table_name %>, format: :json)