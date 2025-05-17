FactoryBot.define do
  factory :securial_user, class: "Securial::User" do
    email_address { Faker::Internet.email }
    password { "password" }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    phone { Faker::PhoneNumber.cell_phone }
    username { Faker::Internet.username(specifier: 3..20) }
    bio { Faker::Lorem.paragraph }
  end
end
