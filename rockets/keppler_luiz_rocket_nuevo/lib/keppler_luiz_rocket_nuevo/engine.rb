module KepplerLuizRocketNuevo
  class Engine < ::Rails::Engine
    isolate_namespace KepplerLuizRocketNuevo
    paths['config/locales']
    config.generators do |g|
      g.template_engine :haml
    end

    config.to_prepare do
      ApplicationController.helper(ApplicationHelper)
    end
  end
end
