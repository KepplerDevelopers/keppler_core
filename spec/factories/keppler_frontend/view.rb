FactoryBot.define do
  factory :keppler_frontend_views, class: KepplerFrontend::View do
    name {'test_index'}
    url {"/test_index"}
    format_result {'HTML'}
    active {true}
  end
end