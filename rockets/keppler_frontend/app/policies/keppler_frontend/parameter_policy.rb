module KepplerFrontend
  # Policy for Parameter model
  class ParameterPolicy < ControllerPolicy
    attr_reader :user, :objects

    def initialize(user, objects)
      @user = user
      @objects = objects
    end
  end
end
