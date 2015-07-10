module SidebarConfiguration

	class << self
    mattr_accessor :routes_sitebar, :keppler_engines
    # add default values of more config vars here
  	end

	# this function maps the vars from your app into your engine
	def self.setup(&block)
	  yield self
	end

end