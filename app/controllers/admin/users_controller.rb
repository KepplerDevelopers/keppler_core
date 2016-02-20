module Admin
  # UsersController
  class UsersController < AdminController
    before_action :set_user, only: [:show, :edit, :update, :destroy]
    before_action :show_history, only: [:index]

    def index
      users = User.searching(@query).where('id != ?', current_user.id)
      @objects = users.page(@current_page)
      @total = users.size
      if !@objects.first_page? && @objects.size.zero?
        redirect_to users_path(page: @current_page.to_i.pred, search: @query)
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
        render action: 'new'
      end
    end

    def destroy
      @user.destroy
      redirect_to users_path, notice: actions_messages(@user)
    end

    def destroy_multiple
      User.destroy redefine_ids(params[:multiple_ids])
      redirect_to(
        users_path(page: @current_page, search: @query),
        notice: actions_messages(User.new)
      )
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(
        :name, :email, :password, :password_confirmation,
        :role_ids, :encrypted_password
      )
    end

    def show_history
      if current_user.has_role? :admin
        @activities = PublicActivity::Activity.where(
          "trackable_type = 'User' or trackable_type = 'Session'"
        ).order('created_at desc').limit(50)
      else
        @activities = PublicActivity::Activity.where(
          "(trackable_type = 'User' or trackable_type = 'Session')
            and owner_id=#{current_user.id}"
        ).order('created_at desc').limit(50)
      end
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
