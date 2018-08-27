module KepplerFrontend
  class ViewCallback < ApplicationRecord
    belongs_to :view

    def set_function_types
      [:before_action, :before_filter, :after_action, :after_filter]
    end
  end
end
