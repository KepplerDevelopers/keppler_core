$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "keppler_languages/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "keppler_languages"
  s.version     = KepplerLanguages::VERSION
  s.authors     = ["pdrowr"]
  s.email       = ["pdrowr@gmail.com"]
  s.homepage    = 'http://keppler.io'
  s.summary     = 'keppler_languages'
  s.description = 'keppler_languages'
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir['test/**/*']

  s.add_dependency 'rails', '5.2.0'
  s.add_dependency 'simple_form'
  s.add_dependency 'haml_rails'
  s.add_dependency 'pundit'
  s.add_dependency 'country_select'
  s.add_development_dependency 'pg'
end
