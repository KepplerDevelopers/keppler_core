module KepplerStarklord
  # Policy for Elliot model
  class ElliotPolicy < ControllerPolicy
    attr_reader :user, :objects
    def initialize(user, objects)
      @user = user
      @objects = objects
    end
  end
end
