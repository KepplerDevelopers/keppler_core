class UsersController < ApplicationController
  before_filter :authenticate_user!
  layout 'admin/application'
  load_and_authorize_resource
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    items = User.searching(@query)
    @users, @total = items.where.not(id: current_user.id).page(@current_page), items.count
    redirect_to users_path if !@users.first_page? and @users.size.zero?
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
    redirect_to users_path, notice: "Usuario eliminado satisfactoriamente" 
  end

  def destroy_multiple
    User.destroy redefine_destroy(params[:multiple_ids])
    redirect_to users_path(page: @current_page, search: @query), notice: "Usuarios eliminados satisfactoriamente" 
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :role_ids, :encrypted_password)
  end

end
