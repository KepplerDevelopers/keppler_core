module KepplerCapsules
  # Policy for CpslPerson model
  class CpslPersonPolicy < ControllerPolicy
    attr_reader :user, :objects

    def initialize(user, objects)
      @user = user
      @objects = objects
    end
  end
end
