# Policy for user model
class UserPolicy < ApplicationPolicy
  attr_reader :user, :objects

  def initialize(user, objects)
    @user = user
    @objects = objects
  end

  def index?
    admin?
  end

  def new?
    create?
  end

  def create?
    admin?
  end

  def edit?
    update?
  end

  def update?
    admin?
  end
end
