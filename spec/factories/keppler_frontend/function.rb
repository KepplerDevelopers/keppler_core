FactoryBot.define do
  factory :keppler_frontend_functions, class: KepplerFrontend::CallbackFunction do
    name {'test_function'}
    description {"test_function"}
    position {0}
    deleted_at {''}
  end
end