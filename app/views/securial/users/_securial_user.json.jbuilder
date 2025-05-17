json.id securial_user.id

json.first_name securial_user.first_name
json.last_name securial_user.last_name
json.phone securial_user.phone
json.username securial_user.username
json.bio securial_user.bio

json.created_at securial_user.created_at
json.updated_at securial_user.updated_at

json.url securial.user_url(securial_user, format: :json)
