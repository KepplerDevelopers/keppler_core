module KepplerFrontend
  # Policy for View model
  class ViewPolicy < ControllerPolicy
    attr_reader :user, :objects

    def initialize(user, objects)
      @user = user
      @objects = objects
    end

    def editor?
      keppler_admin? || user_can?(@objects, 'edit_html')
    end
  end
end
