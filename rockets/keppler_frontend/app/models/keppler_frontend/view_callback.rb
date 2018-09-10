module KepplerFrontend
  class ViewCallback < ApplicationRecord
    belongs_to :view
    before_destroy :delete_callback_line
    validate :uniqueness_callback

    def set_function_types
      [:before_action, :before_filter, :after_action, :after_filter]
    end

    def set_callbacks
      callbacks = KepplerFrontend::CallbackFunction.all.map
      callbacks.map { |v| [v.name, v.name] }
    end

    def callback_exists?
      callback = ViewCallback.where(
        function_type: self.function_type,
        name: self.name)
      callback.count == 0 ? false : true
    end

    private

    def delete_callback_line
      self.view.delete_callback(self.view, self)
    end

    def uniqueness_callback
      errors.add(:name) if callback_exists?
    end
  end
end
