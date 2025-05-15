json.extract! securial_role, :id, :role_name, :hide_from_profile
json.extract! securial_role, :created_at, :updated_at
json.url securial.roles_url(securial_role, format: :json)
