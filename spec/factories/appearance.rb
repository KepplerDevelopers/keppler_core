FactoryBot.define do
  factory :appearance, class: Appearance do
    image_background {"/upload/1/image.jpg"}
    theme_name {Faker::Name.first_name}
    
    before :create do |appearance|
      appearance.setting_id = create(:setting).id
    end
  end
end