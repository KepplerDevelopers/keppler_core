module Admin
  # RolesController
  class RolesController < AdminController
    before_action :set_role, only: %i[show edit update destroy add_permissions create_permissions toggle_actions create_first_permission]
    before_action :show_history, only: [:index]
    before_action :set_attachments

    # GET /roles
    def index
      @q = Role.ransack(params[:q])
      roles = @q.result(distinct: true)
      @objects = roles.page(@current_page).order(position: :desc)
      @total = roles.size
      @roles = @objects.order(:position)
      if !@objects.first_page? && @objects.size.zero?
        redirect_to roles_path(page: @current_page.to_i.pred, search: @query)
      end
    end

    # GET /roles/1
    def show
    end

    # GET /roles/new
    def new
      @role = Role.new
    end

    # GET /roles/1/edit
    def edit
      authorize @role
    end

    # POST /roles
    def create
      @role = Role.new(role_params)

      if @role.save
        redirect_to admin_role_add_permissions_path(@role)
      else
        render :new
      end
    end

    # PATCH/PUT /roles/1
    def update
      if @role.update(role_params)
        redirect(@role, params)
      else
        render :edit
      end
      authorize @role
    end

    def clone
      @role = Role.clone_record params[:role_id]
      if @role.save
        redirect_to admin_roles_path
      else
        render :new
      end
      authorize @role
    end

    # DELETE /roles/1
    def destroy
      @role.destroy
      redirect_to admin_roles_path, notice: actions_messages(@role)
      authorize @role
    end

    def destroy_multiple
      Role.destroy redefine_ids(params[:multiple_ids])
      redirect_to(
        admin_roles_path(page: @current_page, search: @query),
        notice: actions_messages(Role.new)
      )
      authorize @role
    end

    def upload
      Role.upload(params[:file])
      redirect_to(
        admin_roles_path(page: @current_page, search: @query),
        notice: actions_messages(Role.new)
      )
      authorize @role
    end

    def download
      @roles = Role.all
      respond_to do |format|
        format.html
        format.xls { send_data(@roles.to_xls) }
        format.json { render :json => @roles }
      end
      authorize @roles
    end

    def reload
      @q = Role.ransack(params[:q])
      roles = @q.result(distinct: true)
      @objects = roles.page(@current_page).order(position: :desc)
    end

    def sort
      Role.sorter(params[:row])
      render :index
    end

    def add_permissions
    end

    def create_permissions
      @module = params[:role][:module]
      @action = params[:role][:action]

      if @role.have_permissions?
        toggle_actions(params[:role][:module], params[:role][:action])
      else
        create_first_permission
      end
      # redirect_to admin_role_add_permissions_path(params[:role_id])
    end

    def show_description
      @module = params[:module]
      @action = params[:action_name]
    end

    private

    def toggle_actions(module_name, action)
      if @role.have_permission_to(module_name)
        @role.toggle_action(module_name, action)
      else
        @role.add_module(module_name, action)
      end
    end

    def create_first_permission
      Permission.create(
        role_id: @role.id,
        modules: create_hash(params[:role][:module], params[:role][:action])
      )
    end

    def create_hash(module_name, actions)
      Hash[module_name, Hash["actions", Array(actions)]]
    end

    def set_attachments
      @attachments = ['logo', 'brand', 'photo', 'avatar', 'cover', 'image',
                      'picture', 'banner', 'attachment', 'pic', 'file']
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_role
      @role = Role.find(params[:role_id])
    end

    # Only allow a trusted parameter "white list" through.
    def role_params
      params.require(:role).permit(:name, :role_id)
    end

    def show_history
      get_history(Role)
    end
  end
end
