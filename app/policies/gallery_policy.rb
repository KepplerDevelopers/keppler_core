# Policy for Gallery model
class GalleryPolicy < ControllerPolicy
  attr_reader :user, :objects

  def initialize(user, objects)
    @user = user
    @objects = objects
  end
end
