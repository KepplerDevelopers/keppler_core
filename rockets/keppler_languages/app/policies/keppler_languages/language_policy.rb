module KepplerLanguages
  # Policy for Language model
  class LanguagePolicy < ControllerPolicy
    attr_reader :user, :objects

    def initialize(user, objects)
      @user = user
      @objects = objects
    end

    def destroy_field?
      true
    end

    def toggle?
      true
    end
  end
end
