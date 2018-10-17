FactoryBot.define do
  factory :keppler_frontend_views, class: KepplerFrontend::View do
    name {Faker::Name.first_name}
    url {"/"}
    format_result {'HTML'}
    active {true}
  end
end