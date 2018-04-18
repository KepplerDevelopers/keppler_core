# Policy for user model
class UserPolicy < ControllerPolicy

  def clone?
    false
  end

  def destroy?
    (keppler_admin? || admin?) && !same_user?(@user)
  end
end
