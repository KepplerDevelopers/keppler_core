class UsersController < ApplicationController
  before_filter :authenticate_user!
  layout 'admin/application'
  load_and_authorize_resource
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :get_page, only: [:destroy]

  def index
    if params[:search] and !params[:search].blank?
      items = User.search(User.query params[:search]).records
      @users, @total = items.order(id: :desc).page(params[:page]), items.count
      redirect_to users_path if !@users.first_page? and @users.size.zero?
    else
      @users = User.where.not(id: current_user.id).order(id: :desc).page params[:page]
      redirect_to users_path if !@users.first_page? and @users.size.zero?
    end
  end

  def new
    @user = User.new
  end

  def show
  end

  def edit
  end
  
  def update
    respond_to do |format|
      update_attributes = user_params.delete_if do |attribute, value|
        case attribute
          when "password"
            value.blank?
          when "password_confirmation"
            value.blank? if user_params.fetch("password").blank?
        end
      end

      if @user.update_attributes(update_attributes)    
        if params.fetch(:commit).eql?("Asignar Rol")
          format.html { redirect_to users_path, :notice => "Rol asignado satisfactoriamente" }
        else
          format.html { redirect_to user_path(@user), :notice => "Usuario actualizado satisfactoriamente" }
        end
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end

    end
  end

  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        @user.add_role Role.find(user_params.fetch(:role_ids)).name
        format.html { redirect_to user_path(@user), notice: "Usuario creado satisfactoriamente" }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path(@size.zero? ? 1 : @current_page), notice: "Usuario eliminado satisfactoriamente" 
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def get_page
    @size = User.page(@user.page).count
    @current_page = @user.page
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :role_ids, :encrypted_password)
  end

end
