module KepplerFrontend
  # Policy for Theme model
  class ThemePolicy < ControllerPolicy
    attr_reader :user, :objects

    def initialize(user, objects)
      @user = user
      @objects = objects
    end
  end
end
