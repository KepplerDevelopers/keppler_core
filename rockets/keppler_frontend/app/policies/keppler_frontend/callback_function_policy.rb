module KepplerFrontend
  # Policy for CallbackFunction model
  class CallbackFunctionPolicy < ControllerPolicy
    attr_reader :user, :objects

    def initialize(user, objects)
      @user = user
      @objects = objects
    end

    def editor?
      keppler_admin? || user_can?(@objects, 'editor')
    end

    def editor_save?
      keppler_admin? || user_can?(@objects, 'editor_save')
    end
  end
end
