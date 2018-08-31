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

    def editor?
      keppler_admin? || user_can?(@objects, 'editor')
    end

    def editor_save?
      keppler_admin? || user_can?(@objects, 'editor_save')
    end
  end
end
