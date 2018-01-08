# KepplerConfiguration Config
module KepplerConfiguration
  # KepplerConfiguration
  class << self
    mattr_accessor :skip_module_devise, :default_per_page, :visible_models
  end

  # this function maps the vars from your app into your engine
  def self.setup
    yield self
  end
end
