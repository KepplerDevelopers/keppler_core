module KepplerContactUs
  module Concerns
    # Concern con la configuracion de parametros de los formulario
    module DestroyMultiple
      extend ActiveSupport::Concern

      included do
        before_action :can_multiple_destroy, only: [:destroy_multiple]
      end

      private

      def model
        ctrlpath = controller_path
        klass = ctrlpath.split('/').split('admin').flatten.join('/')
        klass.classify.constantize
      end

      def redefine_ids(ids)
        ids.delete('[]').split(',').select do |id|
          id if model.exists? id
        end
      end

      # Check whether the user has permission to delete
      # each of the selected objects
      def can_multiple_destroy
        redefine_ids(params[:multiple_ids]).each do |id|
          authorize model
        end
      end
    end
  end
end
