# Application Policy
class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, objects)
    @user = user
    @objects = objects
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
end
