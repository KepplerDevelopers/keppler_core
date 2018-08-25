module KepplerFrontend
  # Policy for Partial model
  class PartialPolicy < ControllerPolicy
    attr_reader :user, :objects

    def initialize(user, objects)
      @user = user
      @objects = objects
    end

    def editor_save?
      true
    end

  end
end
