FactoryBot.define do
  factory :user, class: User do
    name {Faker::Name.first_name}
    username {Faker::Name.first_name}
    email {Faker::Internet.email}
    password '12345678'
    password_confirmation '12345678'
    role_ids '1'
  end
end
