module KepplerFrontend
  module Concerns
    # Concern con la configuracion de parametros de los formulario
    module Yml
      extend ActiveSupport::Concern

      def update_functions_yml
        functions = KepplerFrontend::Function.all
        file =  File.join("#{Rails.root}/rockets/keppler_frontend/config/functions.yml")
        data = functions.as_json.to_yaml
        File.write(file, data)
      end

      def update_parameters_yml
        parameters = KepplerFrontend::Parameter.all
        file =  File.join("#{Rails.root}/rockets/keppler_frontend/config/parameters.yml")
        data = parameters.as_json.to_yaml
        File.write(file, data)
      end

      private

    end
  end
end
