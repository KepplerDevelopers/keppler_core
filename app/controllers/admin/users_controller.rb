module Admin
  # UsersController
  class UsersController < AdminController
    before_action :set_user, only: [:show, :edit, :update, :destroy]
    before_action :set_roles, only: [:index, :new, :edit, :create, :update]
    before_action :show_history, only: [:index]

    def index
      @q = User.ransack(params[:q])
      users = @q.result(distinct: true).where('id != ?', User.first.id).order(created_at: :desc)
      @objects = users.page(@current_page)
      @total = users.size
      @users = User.all.reverse

      if !@objects.first_page? && @objects.size.zero?
        redirect_to users_path(page: @current_page.to_i.pred, search: @query)
      end
      respond_to do |format|
        format.html
        format.json { render :json => @objects }
      end
    end

    def new
      @user = User.new
      respond_to do |format|
        format.html
        format.json { render :json => @user }
      end

      authorize @user
    end

    def show
    end

    def edit
      authorize @user
    end

    def update
      update_attributes = user_params.delete_if do |_, value|
        value.blank?
      end

      if @user.update_attributes(update_attributes)
        redirect(@user, params)
      else
        render action: 'edit'
      end
      authorize @user
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
      authorize @user
    end

    def destroy_multiple
      # byebug
      User.destroy redefine_ids(params[:multiple_ids])
      redirect_to(
        admin_users_path(page: @current_page, search: @query),
        notice: actions_messages(User.new)
      )
      authorize @user
    end

    def reload
      @q = User.ransack(params[:q])
      users = @q.result(distinct: true).where('id != ?', User.first.id).order(created_at: :desc)
      @objects = users.page(@current_page)
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def set_roles
      all_roles = Role.all.map { |rol| [rol.name.humanize, rol.id] }
      @roles = all_roles.drop(1)
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
