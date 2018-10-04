module KepplerCapsules
  # Policy for Elliot model
  class UserPolicy < ControllerPolicy
    attr_reader :user, :objects
    def initialize(user, objects)
      @user = user
      @objects = objects
    end
  end
end
