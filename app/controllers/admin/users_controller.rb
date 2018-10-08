# frozen_string_literal: true

module Admin
  # UsersController
  class UsersController < AdminController
    before_action :set_user, only: %i[show edit update destroy]
    before_action :set_roles, only: %i[index new edit create update]
    before_action :show_history, only: %i[index]
    before_action :authorization, except: %i[reload filter_by_role]
    before_action :set_users, only: %i[index filter_by_role reload]
    include ObjectQuery

    def index
      @q = User.ransack(params[:q])
      @users = @q.result(distinct: true).where.not(name: 'Keppler Admin')
      @objects = @users.page(@current_page).order(position: :desc)
      @total = @users.size
      redirect_to_index(@objects)
      respond_to_formats(@users)
    end

    def filter_by_role
      return @users = User.all.drop(1) if params[:role].eql?('all')
      @users = User.filter_by_role(@objects, params[:role])
    end

    def new
      @user = User.new
      respond_to_formats(@user)
    end

    def show; end

    def edit; end

    def update
      update_attributes = user_params.delete_if do |_, value|
        value.blank?
      end

      if @user.update_attributes(update_attributes)
        redirect(@user, params)
      else
        render action: 'edit'
      end
    end

    def create
      @user = User.new(user_params)
      if @user.save
        @user.add_role Role.find(user_params.fetch(:role_ids)).name
        redirect(@user, params)
      else
        render 'new'
      end
    end

    def destroy
      @user.destroy
      redirect_to admin_users_path, notice: actions_messages(@user)
    end

    def destroy_multiple
      User.destroy redefine_ids(params[:multiple_ids])
      redirect_to(
        admin_users_path(page: @current_page, search: @query),
        notice: actions_messages(User.new)
      )
    end

    def reload; end

    private

    def set_user
      if params[:id].eql?('clients') || params[:id].eql?('admins')
        redirect_to action: :index, role: params[:id]
      else
        @user = User.find(params[:id])
      end
    end

    def set_users
      @q = User.ransack(params[:q])
      users = @q.result(distinct: true).where('id != ?', User.first.id)
      users = users.order(created_at: :desc)
      @objects = users.page(@current_page)
      @total = users.size
    end

    def set_roles
      all_roles = Role.all.map { |rol| [rol.name.humanize, rol.id] }
      @roles = all_roles.drop(1)
    end

    def authorization
      authorize User
    end

    def user_params
      params.require(:user).permit(
        :name, :email, :password, :password_confirmation,
        :role_ids, :encrypted_password, :avatar
      )
    end

    def show_history
      get_history(User)
    end

    # Get submit key to redirect, only [:create, :update]
    def redirect(object, commit)
      if commit.key?('_save')
        redirect_to admin_user_path(object), notice: actions_messages(object)
      elsif commit.key?('_add_other')
        redirect_to new_admin_user_path, notice: actions_messages(object)
      elsif commit.key?('_assing_rol')
        redirect_to admin_users_path, notice: actions_messages(object)
      end
    end
  end
end
