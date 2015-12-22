require "#{Rails.root}/lib/keppler_configuration.rb"

KepplerConfiguration.setup do |config|
	config.skip_module_devise = [:registrations] # acepta array, permite escoger los modulos de devise, ejemplo: [:registrations, :confirmations]
	config.default_per_page = 25 #acepta integer, permite escoger la cantidad de items por pagina en el index
	config.visible_models =  YAML.load_file("#{Rails.root}/config/menu.yml").values.each { |hash| hash.symbolize_keys! }
end