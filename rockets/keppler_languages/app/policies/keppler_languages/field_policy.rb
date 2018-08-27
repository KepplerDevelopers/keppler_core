module KepplerLanguages
  # Policy for Field model
  class FieldPolicy < ControllerPolicy
    attr_reader :user, :objects

    def initialize(user, objects)
      @user = user
      @objects = objects
    end
  end
end
