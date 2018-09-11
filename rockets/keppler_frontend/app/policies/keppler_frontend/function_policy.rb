module KepplerFrontend
  # Policy for Function model
  class FunctionPolicy < ControllerPolicy
    attr_reader :user, :objects

    def initialize(user, objects)
      @user = user
      @objects = objects
    end

    def editor_save?
      true
    end

    def destroy_param?
      true
    end
  end
end
