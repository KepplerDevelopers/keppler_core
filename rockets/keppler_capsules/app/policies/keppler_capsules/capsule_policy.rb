module KepplerCapsules
  # Policy for Capsule model
  class CapsulePolicy < ControllerPolicy
    attr_reader :user, :objects

    def initialize(user, objects)
      @user = user
      @objects = objects
    end
  end
end
