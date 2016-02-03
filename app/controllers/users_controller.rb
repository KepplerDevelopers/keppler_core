class UsersController < ApplicationController
  before_filter :authenticate_user!
  layout 'admin/application'
  load_and_authorize_resource
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :show_history, only: [:index]

  def index
    users = User.searching(@query).where.not(id: current_user.id)
    @objects, @total = users.page(@current_page), users.size        
    redirect_to users_path(page: @current_page.to_i.pred, search: @query) if !@objects.first_page? and @objects.size.zero?
  end

  def new
    @user = User.new
  end

  def show
  end

  def edit
  end
  
  def update
    update_attributes = user_params.delete_if do |attribute, value|
      case attribute
        when "password"
          value.blank?
        when "password_confirmation"
          value.blank? if user_params.fetch("password").blank?
      end
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
      render action: 'new'
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path, notice: t('keppler.messages.successfully.deleted', model: t("keppler.models.singularize.user").humanize)
  end

  def destroy_multiple
    User.destroy redefine_ids(params[:multiple_ids])
    redirect_to users_path(page: @current_page, search: @query), notice: t('keppler.messages.successfully.removed', model: t("keppler.models.pluralize.user").humanize)
  end

  private
  
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :role_ids, :encrypted_password)
  end
  
  def show_history
    if current_user.has_role? :admin
      @activities = PublicActivity::Activity.where("trackable_type = 'User' or trackable_type = 'Session'").order("created_at desc").limit(50)
    else
      @activities = PublicActivity::Activity.where("(trackable_type = 'User' or trackable_type = 'Session') and owner_id=#{current_user.id}").order("created_at desc").limit(50)
    end
  end

  # Get submit key to redirect, only [:create, :update]
  def redirect(object, commit)
    if commit.has_key?("_save")
      redirect_to user_path(object), notice: t("keppler.messages.successfully.#{action_name}d", model: t("keppler.models.singularize.user").humanize)
    elsif commit.has_key?("_add_other")
      redirect_to new_user_path, notice: t("keppler.messages.successfully.#{action_name}d", model: t("keppler.models.singularize.user").humanize)
    elsif commit.has_key?("_assing_rol")
      redirect_to users_path, notice: t("keppler.messages.successfully.#{action_name}d", model: t("keppler.models.singularize.user").humanize)
    end    
  end

end
