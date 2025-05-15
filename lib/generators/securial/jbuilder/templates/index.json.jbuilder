json.array! @<%= plural_table_name %> do |<%= singular_table_name %>|
  json.partial! "securial/<%= name.pluralize.downcase %>/<%= singular_table_name %>", <%= singular_table_name %>: <%= singular_table_name %>
end