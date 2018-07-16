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
        @role.toggle_actions(@module, @action)
      else
        @role.first_permission(@module, @action)
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
  end
end
