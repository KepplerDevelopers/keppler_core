# frozen_string_literal: true

# Application Policy
class ApplicationPolicy
  attr_reader :user, :record

  def keppler_admin?
    user.keppler_admin?
  end

  def same_user?(id)
    user.id.eql?(id)
  end

  def user_can?(objects, method)
    user.can?(objects.model_name.name.split('::').join(''), method)
  end
end
