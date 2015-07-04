require "#{Rails.root}/lib/engine_rails.rb"

EngineRails.setup do |config|
	
  config.routes_sitebar={}
  config.routes_dropdown = []

  Rails::Engine.subclasses.each do |engine| 
  	if engine.parent.constants.include? :SITEBAR
  		config.routes_sitebar.merge!(engine.parent::SITEBAR)
  	elsif engine.parent.constants.include? :DROPDOWN
  		config.routes_dropdown << engine.parent::DROPDOWN
  	end
  end

  config.list_engines =  Rails::Engine::subclasses.map { |x| x.parent.to_s.underscore.to_sym }
  
end
