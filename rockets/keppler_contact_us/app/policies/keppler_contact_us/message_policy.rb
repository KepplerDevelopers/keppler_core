module KepplerContactUs
  # Policy for Message model
  class MessagePolicy < ControllerPolicy
    attr_reader :user, :objects

    def initialize(user, objects)
      @user = user
      @objects = objects
    end

    def index?
      keppler_admin? || user_can?(@objects, 'index')
    end

    def upload?
      false
    end

    def update?
      false
    end

    def send?
      index?
    end

    def favorite?
      index?
    end

    def reload?
      index?
    end

    def show?
      index?
    end

    def reply?
      show?
    end

    def share?
      show?
    end

    def print?
      show?
    end

    def read? 
      index?
    end 

    def unread?
      index?
    end 

    def favorites?
      index?
    end
  end
end
