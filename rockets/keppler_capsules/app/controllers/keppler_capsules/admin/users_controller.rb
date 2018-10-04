# frozen_string_literal: true

require_dependency "keppler_capsules/application_controller"
module KepplerCapsules
  module Admin
    # UsersController
    class UsersController < ::Admin::AdminController
      layout 'keppler_capsules/admin/layouts/application'
      before_action :set_user, only: %i[show edit update destroy]
      include ObjectQuery

      # GET /users
      def index
        @q = User.ransack(params[:q])
        @users = @q.result(distinct: true)
        @objects = @users.page(@current_page).order(position: :desc)
        @total = @users.size
        redirect_to_index(@objects)
        respond_to_formats(@users)
      end

      # GET /users/1
      def show; end

      # GET /users/new
      def new
        @user = User.new
      end

      # GET /users/1/edit
      def edit; end

      # POST /users
      def create
        @user = User.new(user_params)

        if @user.save
          redirect(@user, params)
        else
          render :new
        end
      end

      # PATCH/PUT /users/1
      def update
        if @user.update(user_params)
          redirect(@user, params)
        else
          render :edit
        end
      end

      def clone
        @user = User.clone_record params[:user_id]

        if @user.save
          redirect_to_index(@objects)
        else
          render :new
        end
      end

      # DELETE /users/1
      def destroy
        @user.destroy
        redirect_to_index(@user)
      end

      def destroy_multiple
        User.destroy redefine_ids(params[:multiple_ids])
        redirect_to_index(@user)
      end

      def upload
        User.upload(params[:file])
        redirect_to_index(@user)
      end

      def reload
        @q = User.ransack(params[:q])
        users = @q.result(distinct: true)
        @objects = users.page(@current_page).order(position: :desc)
      end

      def sort
        User.sorter(params[:row])
        @q = User.ransack(params[:q])
        users = @q.result(distinct: true)
        @objects = users.page(@current_page).order(position: :desc)
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_user
        @user = User.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def user_params
        params.require(:user).permit(
          :name, :bio, :position, :deleted_at
        )
      end
    end
  end
end
