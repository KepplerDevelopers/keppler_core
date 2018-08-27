module KepplerCapsules
  module Concerns
    # Concern con la configuracion de parametros de los formulario
    module Lib
      extend ActiveSupport::Concern

      def capsule(name)
        name = name.singularize.downcase.capitalize
        "KepplerCapsules::#{name}".constantize
      end
    end
  end
end
