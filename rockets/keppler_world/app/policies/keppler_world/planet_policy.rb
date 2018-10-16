module KepplerWorld
  # Policy for Planet model
  class PlanetPolicy < ControllerPolicy
    attr_reader :user, :objects
    def initialize(user, objects)
      @user = user
      @objects = objects
    end
  end
end
