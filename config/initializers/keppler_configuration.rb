require "#{Rails.root}/lib/keppler_configuration.rb"

KepplerConfiguration.setup do |config|
  # Allows you to choose the devise modules you want to skip
  #   example: [:registrations, :confirmations]
  config.skip_module_devise = [:registrations]
  # Allows you to choose the number of rows to show per page
  config.default_per_page = 25

  # Load sidebar menu fom config/menu.yml
  config.visible_models = YAML.load_file(
    "#{Rails.root}/config/menu.yml"
  ).values.each(&:symbolize_keys!)
end
