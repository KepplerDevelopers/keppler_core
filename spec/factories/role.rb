FactoryBot.define do
  factory :role, class: Role do
    name {Faker::Name.first_name}
    position '1'
    resource_type nil
    resource_id nil
  end
end