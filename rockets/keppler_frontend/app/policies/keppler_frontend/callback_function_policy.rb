module KepplerFrontend
  # Policy for CallbackFunction model
  class CallbackFunctionPolicy < ControllerPolicy
    attr_reader :user, :objects

    def initialize(user, objects)
      @user = user
      @objects = objects
    end
  end
end
