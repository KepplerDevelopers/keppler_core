module KepplerFrontend
  module Concerns
    # Concern con la configuracion de parametros de los formulario
    module Services
      extend ActiveSupport::Concern

      private

      def views
        KepplerFrontend::Views::Views.new
      end

      def theme_view
        KepplerFrontend::Views::ThemeViews.new
      end

      def resources
        KepplerFrontend::Editor::Resources.new
      end

      def route_handler
        KepplerFrontend::Views::RoutesHandler.new
      end
    end
  end
end
