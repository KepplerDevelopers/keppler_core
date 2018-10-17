FactoryBot.define do
  factory :script, class: Script do
    name {Faker::Name.first_name}
    script {'MyStrig'}
    url {'www.keppleradmin.com'}
    position {1}
  end
end
