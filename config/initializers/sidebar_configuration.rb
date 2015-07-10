require "#{Rails.root}/lib/sidebar_configuration.rb"

SidebarConfiguration.setup do |config|
	
  config.keppler_engines =  Rails::Engine::subclasses.map { |e| e.parent if e.parent.constants.include? :ROUTES_TREE_SIDEBAR or e.parent.constants.include? :ROUTE_SIDEBAR } .compact
  
end
