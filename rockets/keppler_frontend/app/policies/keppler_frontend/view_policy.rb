module KepplerFrontend
  # Policy for View model
  class ViewPolicy < ControllerPolicy
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

    def live_editor_save?
      keppler_admin? || user_can?(@objects, 'live_editor_save')
    end

    def select_theme_view?
      keppler_admin? || user_can?(@objects, 'select_theme_view')
    end

    def multimedia?
      keppler_admin? || user_can?(@objects, 'multimedia')
    end

    def upload_multimedia?
      keppler_admin? || user_can?(@objects, 'upload_multimedia')
    end

    def destroy_callback?
      keppler_admin? || user_can?(@objects, 'destroy_callback')
    end
  end
end
