# Policy for <%= controller_class_name.singularize %> model
class <%= controller_class_name.singularize %>Policy < ApplicationPolicy
  attr_reader :user, :objects

  def initialize(user, objects)
    @user = user
    @objects = objects
  end
end
