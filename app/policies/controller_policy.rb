# Application Policy
class ControllerPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, objects)
    @user = user
    @objects = objects
  end

  def index?
    true
  end

  def new?
    create?
  end

  def create?
    keppler_admin? || admin?
  end

  def edit?
    update?
  end

  def update?
    keppler_admin? || admin?
  end

  def clone?
    keppler_admin? || admin?
  end

  def show?
    true
  end

  def destroy_multiple?
    destroy?
  end

  def destroy?
    keppler_admin? || admin?
  end

  def upload?
    keppler_admin? || admin?
  end

  def download?
    keppler_admin? || admin?
  end
end
