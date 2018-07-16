# frozen_string_literal: true

# Policy for scripts model
class ScriptPolicy < ControllerPolicy
  attr_reader :user, :objects

  def initialize(user, objects)
    @user = user
    @objects = objects
  end
end
