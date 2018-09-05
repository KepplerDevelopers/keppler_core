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
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "5.2.0"
  s.add_development_dependency "pg"
end
