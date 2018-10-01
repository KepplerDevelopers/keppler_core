# frozen_string_literal: true

module Admin
  # PermissionsController
  class PermissionsController < AdminController
    before_action :set_role

    def add; end

    def create
      @module = params[:role][:module]
      @action = params[:role][:action]
      @actions = params[:role][:actions]

      if @role.permissions?
        @role.toggle_actions(@module, @action)
      else
        @role.first_permission(@module, @action)
      end
    end

    def show
      @module = params[:module]
      @action = params[:action_name]
    end

    def toggle_permissions
      @module = params[:role][:module]
      all_actions = params[:role][:actions]
      if @role.permissions?
        add_actions_or_module(@module, all_actions)
      else
        @actions = all_actions
        @role.first_permission(@module, @actions)
      end
    end

    private

    def add_actions_or_module(module_name, actions)
      if @role.permission_to(module_name)
        @actions = (actions - @role.all_permissions[module_name]['actions'])
        @role.toggle_all_actions(module_name, actions)
      else
        @role.add_module(module_name, actions)
      end

      @actions = actions if @actions.blank?
    end

    def set_role
      @role = Role.find(params[:role_id])
    end
  end
end
