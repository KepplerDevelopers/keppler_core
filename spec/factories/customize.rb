FactoryBot.define do
  factory :customize, class: Customize do
    file {'/upload/template/theme.zip'}
    installed {true}
  end
end