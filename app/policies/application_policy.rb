# frozen_string_literal: true

# Application Policy
class ApplicationPolicy
  attr_reader :user, :record

  def keppler_admin?
    user&.keppler_admin?
  end

  def same_user?(id)
    user.id.eql?(id)
  end

  def user_can?(objects, method)
    return false unless user
    model = objects.model_name.name.split('::').join('')
    permissions = user.permissions.select { |key, _hash| key == model }
    permissions[model] && permissions[model]['actions'].include?(method)
  end
end
