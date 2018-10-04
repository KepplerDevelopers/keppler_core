module KepplerStarklord
  module Concerns
    # Concern con la configuracion de parametros de los formulario
    module History
      extend ActiveSupport::Concern

      included do
        before_action :history, only: [:index]
      end

      private

      def history
        @activities = PublicActivity::Activity.where(
          trackable_type: model.to_s
        ).order('created_at desc').limit(50)
      end
    end
  end
end
