# frozen_string_literal: true

# Policy for rockets model
class RocketPolicy < ControllerPolicy
  attr_reader :user, :object

  def initialize(user, object)
    @user = user
    @object = object
  end

  def rockets?
    keppler_admin?
  end

  def create?
    keppler_admin?
  end

  def install?
    keppler_admin?
  end

  def uninstall?
    @object.name && Rocket.core_depending.exclude?(@object.name)
  end

  def build
    keppler_admin?
  end
end
