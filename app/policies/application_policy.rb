# Application Policy
class ApplicationPolicy
  attr_reader :user, :record

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

  def import?
    keppler_admin? || admin?
  end

  def keppler_admin?
    user.keppler_admin?
  end

  def admin?
    user.admin?
  end

  def same_user?(id)
    user.id.eql?(id)
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end
  end
end
