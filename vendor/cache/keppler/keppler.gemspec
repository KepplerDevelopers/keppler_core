
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "keppler/version"

Gem::Specification.new do |spec|
  spec.name          = "keppler"
  spec.version       = Keppler::VERSION
  spec.authors     = ["Luis Perez"]
  spec.email       = 'luis.prz7@gmail.com'
  spec.summary       = "Keppler Administrator"
  spec.description   = "Keppler Administrator"
  spec.homepage      = 'https://rubygems.org/gems/keppler'
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org/gems/keppler"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files`.split("\n")
  spec.bindir        = "exe"
  spec.executables   = ['keppler']
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_dependency 'thor'
  spec.add_dependency 'httparty'

end
