# Set up gems listed in the Gemfile.
# ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

# require 'bundler/setup' if File.exist?(ENV['BUNDLE_GEMFILE'])
require 'bundler/setup' # Set up gems listed in the Gemfile.
require 'bootsnap/setup' # Speed up boot time by caching expensive operations.
