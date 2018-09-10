$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "keppler_anyelo/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "keppler_anyelo"
  s.version     = KepplerAnyelo::VERSION
  s.authors     = ["Anyelo Petit"]
  s.email       = ["anyelopetit@gmail.com"]
  s.homepage    = "http://keppler.io"
  s.summary     = "Summary: Summary of KepplerAnyelo."
  s.description = "Description: Description of KepplerAnyelo."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.2.0"

  s.add_development_dependency "sqlite3"
end
