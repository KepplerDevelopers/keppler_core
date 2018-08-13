module KepplerFrontend
  # Policy for Theme model
  class ThemePolicy < ControllerPolicy
    attr_reader :user, :objects

    def initialize(user, objects)
      @user = user
      @objects = objects
    end

    def show_covers?
      keppler_admin? || user_can?(@objects, 'show_covers')
    end
  end
end
