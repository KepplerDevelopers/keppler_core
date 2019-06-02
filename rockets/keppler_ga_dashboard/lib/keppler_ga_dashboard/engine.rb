module KepplerGaDashboard
  class Engine < ::Rails::Engine
    require 'google/api_client'
    require 'gon'

    isolate_namespace KepplerGaDashboard

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_bot #newly added code
      g.factory_bot dir: 'spec/factories' #newly added code
    end

    # new code
    initializer "sample_engine.factories", after: "factory_bot.set_factory_paths" do
      FactoryBot.definition_file_paths << File.expand_path('../../../spec/factories', __FILE__) if defined?(FactoryBot)
    end
  end
end
