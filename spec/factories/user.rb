FactoryBot.define do
  factory :user, class: User do
    name 'Keppler Admin'
    username 'keppler_admin'
    email 'admin@kepplertest.io'
    password '12345678'
    password_confirmation '12345678'
    role_ids '1'
  end
end
