# frozen_string_literal: true

# Policy for Seo model
class SeoPolicy < ControllerPolicy
  attr_reader :user, :objects

  def initialize(user, objects)
    @user = user
    @objects = objects
  end

  def sitemap?
    true
  end

  def robots?
    true
  end

  def editor_save?
    true
  end
end
