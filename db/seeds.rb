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

Role.create name: 'keppler_admin'
puts 'Role Keppler Admin has been created'


User.create(
  name: 'Keppler Admin', email: 'admin@keppleradmin.com', password: '+12345678+',
  password_confirmation: '+12345678+', role_ids: '1'
)

puts 'admin@keppler.io has been created'


# Create setting deafult
if yml = YAML.load_file("#{Rails.root}/config/settings.yml")
  setting = Setting.create(
    name: yml['name'],
    description: yml['description'],
    email: yml['email'],
    phone: yml['phone'],
    mobile: yml['mobile'],
    smtp_setting_attributes: {
      address: yml['address'],
      port: yml['port'],
      domain_name: yml['domain_name'],
      email: yml['smtp_email'],
      password: yml['password'] ? yml['password'] : '12345678'
    },
    google_analytics_setting_attributes: {
      ga_account_id: yml['ga_account_id'],
      ga_tracking_id: yml['ga_tracking_id'],
      ga_status: yml['ga_status']
    }
  )
  setting.social_account = SocialAccount.new(
    facebook: yml['facebook'],
    twitter: yml['twitter'],
    instagram: yml['instagram'],
    google_plus: yml['google_plus'],
    tripadvisor: yml['tripadvisor'],
    pinterest: yml['pinterest'],
    flickr: yml['flickr'],
    behance: yml['behance'],
    dribbble: yml['dribbble'],
    tumblr: yml['tumblr'],
    github: yml['github'],
    linkedin: yml['linkedin'],
    soundcloud: yml['soundcloud'],
    youtube: yml['youtube'],
    skype: yml['skype'],
    vimeo: yml['vimeo']
  )
  setting.appearance = Appearance.new(theme_name: yml['theme_name'])
  setting.save!
  puts 'Setting has been created'
else
  setting = Setting.create(
    name: 'Keppler Admin', description: 'Welcome to Keppler Admin',
    smtp_setting_attributes: {
      address: 'test', port: '25', domain_name: 'keppler.com',
      email: 'info@keppler.com', password: '12345678'
    },
    google_analytics_setting_attributes: {
      ga_account_id: '121648466',
      ga_tracking_id: 'UA-121648466-1',
      ga_status: true
    }
  )
  setting.social_account = SocialAccount.new
  setting.appearance = Appearance.new(theme_name: 'keppler')
  setting.save
  puts 'Setting default has been created'
end

if defined?(KepplerFrontend) && KepplerFrontend.is_a?(Module)
  file =  File.join("#{Rails.root}/rockets/keppler_frontend/config/data/views.yml")
  routes = YAML.load_file(file)
  routes.each do |route|
    KepplerFrontend::View.create(
      name: route['name'],
      url: route['url'],
      method: route['method'],
      active: route['active'],
      format_result: route['format_result']
    )
  end

  partials_file =  File.join("#{Rails.root}/rockets/keppler_frontend/config/partials.yml")
  partials = YAML.load_file(partials_file)

  partials.each do |partial|
    KepplerFrontend::Partial.create(
      name: partial['name'],
    )
  end
  puts 'Views and Partials has been created'
end

if defined?(KepplerLanguages) && KepplerLanguages.is_a?(Module)
  languages =  File.join("#{Rails.root}/rockets/keppler_languages/config/languages.yml")
  langs = YAML.load_file(languages)

  langs.each do |lang|
    KepplerLanguages::Language.create(
      name: lang['name']
    )
  end

  file_fields =  File.join("#{Rails.root}/rockets/keppler_languages/config/fields.yml")
  fields = YAML.load_file(file_fields)

  fields.each do |field|
    KepplerLanguages::Field.create(
      key: field['key'],
      value: field['value'],
      language_id: field['language_id']
    )
  end
  puts 'Languages has been created'
end

if defined?(KepplerFrontend) && KepplerFrontend.is_a?(Module)
  functions =  File.join("#{Rails.root}/rockets/keppler_frontend/config/functions.yml")
  funcs = YAML.load_file(functions)

  funcs.each do |func|
    KepplerFrontend::Function.create(
      name: func['name'],
      description: func['description']
    )
  end

  parameters_file =  File.join("#{Rails.root}/rockets/keppler_frontend/config/parameters.yml")
  params = YAML.load_file(parameters_file)

  params.each do |param|
    KepplerFrontend::Parameter.create(
      name: param['name'],
      function_id: param['function_id']
    )
  end
  puts 'Frontend functions has been created'
end