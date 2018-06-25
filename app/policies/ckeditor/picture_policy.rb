# frozen_string_literal: true

module Ckeditor
  # PicturePolicy
  class PicturePolicy
    attr_reader :user, :picture

    def initialize(user, picture)
      @user = user
      @picture = picture
    end

    def index?
      user.present?
    end

    def create?
      user.present?
    end

    def destroy?
      user.present?
    end
  end
end
