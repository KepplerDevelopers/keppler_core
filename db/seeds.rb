# This file should contain all the record creation needed to seed
# the database with its default values.
# The data can then be loaded with the rake db:seed
# (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# user = CreateAdminService.new.call
# puts 'CREATED ADMIN USER: ' << user.email

[:admin, :client].each do |name|
  Role.create name: name
  puts "#{name} has been created"
end

User.create(
  name: 'Admin', email: 'admin@keppler.com', password: '12345678',
  password_confirmation: '12345678', role_ids: '1'
)

puts 'admin@keppler.com has been created'

# Create setting deafult
setting = Setting.new(
  name: 'Keppler Admin', description: 'Welcome to Keppler Admin',
  smtp_setting_attributes: {
    address: 'test', port: '25', domain_name: 'keppler.com',
    email: 'info@keppler.com', password: '12345678'
  },
  google_analytics_setting_attributes: {
    ga_account_id: '60688852',
    ga_tracking_id: 'UA-60688852-1',
    ga_status: true
  }
)
setting.social_account = SocialAccount.new
setting.appearance = Appearance.new(theme_name: 'keppler')
setting.save
puts 'Setting default has been created'
