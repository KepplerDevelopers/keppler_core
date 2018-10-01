<% module_namespacing do -%>
# Policy for <%= controller_class_name.singularize %> model
class <%= controller_class_name.singularize %>Policy < ControllerPolicy
  attr_reader :user, :objects
  def initialize(user, objects)
    @user = user
    @objects = objects
  end
end
<% end -%>