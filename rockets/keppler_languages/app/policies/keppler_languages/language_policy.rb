module KepplerLanguages
  # Policy for Language model
  class LanguagePolicy < ControllerPolicy
    attr_reader :user, :objects

    def initialize(user, objects)
      @user = user
      @objects = objects
    end

    def add_fields?
      true
    end

    def create_fields?
      true
    end

  end
end
