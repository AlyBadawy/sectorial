json.extract! password, :id, :forgot_password, :reset_password, :created_at, :updated_at
json.url password_url(password, format: :json)
