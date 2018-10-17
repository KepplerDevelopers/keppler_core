FactoryBot.define do
  factory :appearance, class: Appearance do
    image_background {"/upload/1/image.jpg"}
    theme_name {Faker::Name.first_name}
    setting_id {'1'}
  end
end