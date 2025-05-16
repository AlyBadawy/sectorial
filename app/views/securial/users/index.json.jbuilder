json.records @users do |user|
  json.partial! "securial/users/user", user: user
end

json.count @users.count
json.url securial.users_url(format: :json)
