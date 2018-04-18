# Application Policy
class ApplicationPolicy
  attr_reader :user, :record

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
