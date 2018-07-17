# frozen_string_literal: true

# Policy for MetaTag model
class MetaTagPolicy < ControllerPolicy
  attr_reader :user, :objects

  def initialize(user, objects)
    @user = user
    @objects = objects
  end
end
