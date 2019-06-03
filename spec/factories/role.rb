FactoryBot.define do
  factory :role, class: Role do
    name { Faker::Name.first_name }
    position {'1'}

    trait :with_keppler_admin do
      name { 'keppler_admin' }
    end
  end
end