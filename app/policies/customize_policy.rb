# Policy for customize model
class CustomizePolicy < ApplicationPolicy
  attr_reader :user, :objects

  def initialize(user, objects)
    @user = user
    @objects = objects
  end
end
