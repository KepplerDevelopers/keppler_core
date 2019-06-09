$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "keppler_ga_dashboard/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "keppler_ga_dashboard"
  s.version     = KepplerGaDashboard::VERSION
  s.authors     = ["Slice group"]
  s.email       = ["contacto@slicegroup.xyz"]
  s.homepage    = "https://www.slicegroup.xyz"
  s.summary     = "Summary of KepplerGaDashboard"
  s.description = ""
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "5.2.0"
  s.add_dependency "gon"
  s.add_dependency "pg"
  s.add_dependency "google-api-client", "0.7.1"
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'factory_bot_rails'
  s.add_development_dependency 'byebug'
  s.add_development_dependency 'bootsnap'
  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'haml-rails'
  s.add_development_dependency 'rails-controller-testing'
end
