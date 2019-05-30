# frozen_string_literal: true

# Policy for rockets model
class RocketPolicy < ControllerPolicy
  attr_reader :user, :objects

  def initialize(user, objects)
    @user = user
    @objects = objects
  end

  def uninstall?
    @objects && !Rocket.core_depending.include?(@objects)
  end
end
