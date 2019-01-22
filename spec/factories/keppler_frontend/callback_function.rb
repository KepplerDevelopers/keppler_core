FactoryBot.define do
  factory :keppler_frontend_callback_functions, class: KepplerFrontend::CallbackFunction do
    name {'test_callback'}
    description {"test_callback"}
    position {0}
    deleted_at {''}
  end
end