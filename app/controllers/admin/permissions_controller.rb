# frozen_string_literal: true

module Admin
  # PermissionsController
  class PermissionsController < AdminController
    before_action :set_role

    def add; end

    def create
      @module = params[:role][:module]
      @action = params[:role][:action]
      if @role.permissions?
        toggle_actions(@module, @action)
      else
        first_permission(@module, @action)
      end
    end

    def show
      @module = params[:module]
      @action = params[:action_name]
    end

    private

    def set_role
      @role = Role.find(params[:role_id])
    end

    def toggle_actions(module_name, action)
      if @role.permission_to(module_name)
        @role.toggle_action(module_name, action)
      else
        @role.add_module(module_name, action)
      end
    end

    def first_permission(module_name, action)
      Permission.create(
        role_id: @role.id,
        modules: create_hash(module_name, action)
      )
    end

    def create_hash(module_name, actions)
      Hash[module_name, Hash['actions', Array(actions)]]
    end
  end
end
