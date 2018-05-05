# Application Policy
class ControllerPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, objects)
    @user = user
    @objects = objects
  end

  def index?
    keppler_admin? || user_can?(@objects, 'index')
  end

  def new?
    create? || user_can?(@objects, 'new')
  end

  def create?
    keppler_admin? || user_can?(@objects, 'create')
  end

  def edit?
    update? || user_can?(@objects, 'edit')
  end

  def update?
    keppler_admin? || user_can?(@objects, 'update')
  end

  def clone?
    keppler_admin? || user_can?(@objects, 'clone')
  end

  def show?
    keppler_admin? || user_can?(@objects, 'show')
  end

  def destroy_multiple?
    destroy?
  end

  def destroy?
    keppler_admin? || user_can?(@objects, 'destroy')
  end

  def import?
    keppler_admin? || user_can?(@objects, 'import')
  end

  def download?
    keppler_admin? || user_can?(@objects, 'download')
  end
end
