FactoryBot.define do
  factory :setting, class: Settings do
    name { Faker::Name.first_name }
    description { Faker::Name.first_name }
    email { Faker::Internet.email }
    phone { Faker::PhoneNumber.phone_number }
    mobile { Faker::PhoneNumber.cell_phone }
  end
end
