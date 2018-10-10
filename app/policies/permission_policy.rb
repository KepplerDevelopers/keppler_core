# frozen_string_literal: true

# Policy for Permission model
class PermissionPolicy < ControllerPolicy
  attr_reader :user, :objects

  def initialize(user, objects)
    @user = user
    @objects = objects
  end

  def clone?
    false
  end

  def add?
    true
  end

  def toggle_permissions?
    true
  end
end
