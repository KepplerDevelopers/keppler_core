# frozen_string_literal: true

# Policy for <%= class_name %> model
<% module_namespacing do -%>
  # Policy for <%= MODULE_CLASS_NAME %> model
  class <%= MODULE_CLASS_NAME %>Policy < ControllerPolicy
    attr_reader :user, :objects

    def initialize(user, objects)
      @user = user
      @objects = objects
    end
  end
<% end -%>