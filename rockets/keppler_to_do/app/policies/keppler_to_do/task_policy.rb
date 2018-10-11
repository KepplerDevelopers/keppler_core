module KepplerToDo
  # Policy for Task model
  class TaskPolicy < ControllerPolicy
    attr_reader :user, :objects
    def initialize(user, objects)
      @user = user
      @objects = objects
    end
  end
end
