# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#user = CreateAdminService.new.call
#puts 'CREATED ADMIN USER: ' << user.email

[:admin].each do |name|
	Role.create name: name
	puts "#{name} creado"
end

User.create name: "Admin", email: "admin@keppler.com", password: "12345678", password_confirmation: "12345678", role_ids: "1"
puts "admin@keppler.com ha sido creado"