module KepplerCapsules
  # Policy for Capsule model
  class CapsulePolicy < ControllerPolicy
    attr_reader :user, :objects

    def initialize(user, objects)
      @user = user
      @objects = objects
    end

    def destroy_field?
      keppler_admin? || user_can?(@objects, 'destroy_field')
    end
  end
end
