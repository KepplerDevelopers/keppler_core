module KepplerCapsules
  # Policy for Catalog model
  class CatalogPolicy < ControllerPolicy
    attr_reader :user, :objects

    def initialize(user, objects)
      @user = user
      @objects = objects
    end
  end
end
