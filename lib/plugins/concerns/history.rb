module KepplerPoll
  module Concerns
    # Concern con la configuracion de parametros de los formulario
    module History
      extend ActiveSupport::Concern

      included do
        before_action :show_history, only: [:index]
      end

      private

      def show_history
        get_history(Room)
      end

      def get_history(model)
        @activities = PublicActivity::Activity.where(
          trackable_type: model.to_s
        ).order('created_at desc').limit(50)
      end
    end
  end
end
