module <%= ROCKET_CLASS_NAME %>
  # Policy for <%= MODULE_CLASS_NAME %> model
  class <%= MODULE_CLASS_NAME %>Policy < ControllerPolicy
    attr_reader :user, :objects

    def initialize(user, objects)
      @user = user
      @objects = objects
    end
  end
end