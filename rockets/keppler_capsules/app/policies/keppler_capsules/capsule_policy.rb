module KepplerCapsules
  # Policy for Capsule model
  class CapsulePolicy < ControllerPolicy
    attr_reader :user, :objects

    def initialize(user, objects)
      @user = user
      @objects = objects
    end

    def destroy_association?
      keppler_admin? || user_can?(@objects, 'destroy_association')
    end

    def destroy_validation?
      keppler_admin? || user_can?(@objects, 'destroy_validation')
    end

    def destroy_field?
      keppler_admin? || user_can?(@objects, 'destroy_field')
    end
  end
end
