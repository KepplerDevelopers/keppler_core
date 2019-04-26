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

    def select_theme?
      keppler_admin? || user_can?(@objects, 'select_theme')
    end

    def refresh?
      keppler_admin? || user_can?(@objects, 'select_theme')
    end

    def generate?
      keppler_admin? || user_can?(@objects, 'select_theme')
    end

    def remove?
      keppler_admin? || user_can?(@objects, 'select_theme')
    end
  end
end
