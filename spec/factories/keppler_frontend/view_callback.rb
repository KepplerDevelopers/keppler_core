FactoryBot.define do
  factory :keppler_frontend_view_callbacks, class: KepplerFrontend::ViewCallback do
    name {'test_callback'}
    function_type {"before_action"}
  end
end