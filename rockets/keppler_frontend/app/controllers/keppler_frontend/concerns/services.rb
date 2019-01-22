module KepplerFrontend
  module Concerns
    # Concern con la configuracion de parametros de los formulario
    module Services
      extend ActiveSupport::Concern

      private

      def resources
        KepplerFrontend::Editor::Resources.new
      end

      def yml_handler
        KepplerFrontend::Utils::YmlHandler
      end
    end
  end
end
