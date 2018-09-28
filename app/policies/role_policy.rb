# frozen_string_literal: true

# Policy for Role model
class RolePolicy < ControllerPolicy
  attr_reader :user, :objects

  def initialize(user, objects)
    @user = user
    @objects = objects
  end

  def clone?
    false
  end

  def add_permissions?
    keppler_admin? || user_can?(@objects, 'add_permissions')
  end

  def create_permissions?
    keppler_admin? || user_can?(@objects, 'create_permissions')
  end

  def show_description?
    keppler_admin? || user_can?(@objects, 'create_permissions')
  end

  def toggle_permissions?
    keppler_admin? || user_can?(@objects, 'toggle_permissions')
  end
end
