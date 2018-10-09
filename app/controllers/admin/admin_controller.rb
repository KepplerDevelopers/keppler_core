# frozen_string_literal: true

module Admin
  # AdminController
  class AdminController < ::ApplicationController
    layout 'admin/layouts/application'
    before_action :authenticate_user!
    before_action :validate_permissions
    before_action :paginator_params
    before_action :set_setting
    before_action :can_multiple_destroy, only: [:destroy_multiple]
    before_action :tables_name
    before_action :attachments
    before_action :authorization
    before_action :history

    def root
      if current_user
        redirect_to dashboard_path
      else
        redirect_to new_user_session_path
      end
    end

    def paginator_params
      @search_field = model.search_field if listing?
      @query = params[:search] unless params[:search].blank?
      @current_page = params[:page] unless params[:page].blank?
    end

    def validate_permissions
      return if current_user.rol.eql?('keppler_admin')
      redirect_to not_authorized_path unless current_user.permissions?
    end

    private

    def attachments
      @attachments = YAML.load_file(
        "#{Rails.root}/config/attachments.yml"
      )
    end

    def only_development
      redirect_to '/admin' if Rails.env.eql?('production')
    end

    def authorization
      table = model.to_s.tableize.underscore.to_sym
      return unless ActiveRecord::Base.connection.table_exists? table
      authorize model
    end

    def get_history(_object)
      history
    end

    def history
      @activities = PublicActivity::Activity.where(
        trackable_type: model.to_s
      ).order('created_at desc').limit(50)
    end

    def tables_name
      @models = ApplicationRecord.connection.tables.map do |model|
        model.capitalize.singularize.camelize
      end
    end

    # Get submit key to redirect, only [:create, :update]
    def redirect(object, commit)
      redirect_to(
        {
          action: (commit.key?('_save') ? :show : :new),
          id: (object.id if commit.key?('_save'))
        },
        notice: actions_messages(object)
      )
    end

    def redefine_ids(ids)
      ids.delete('[]').split(',').select do |id|
        id if model.exists? id
      end
    end

    # Check whether the user has permission to delete
    # each of the selected objects
    def can_multiple_destroy
      redefine_ids(params[:multiple_ids]).each do |id|
        authorize model.find(id)
      end
    end
  end
end
