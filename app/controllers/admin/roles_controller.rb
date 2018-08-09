# frozen_string_literal: true

module Admin
  # RolesController
  class RolesController < AdminController
    before_action :set_role, only: %i[show edit update destroy]
    before_action :show_history, only: [:index]
    before_action :set_attachments
    before_action :authorization, except: %i[reload]
    include ObjectQuery

    # GET /roles
    def index
      @q = Role.ransack(params[:q])
      @roles = @q.result(distinct: true)
      @objects = @roles.page(@current_page).order(position: :desc)
      @total = @roles.size
      redirect_to_index(roles_path) if nothing_in_first_page?(@objects)
      respond_to_formats(@roles)
    end

    # GET /roles/1
    def show; end

    # GET /roles/new
    def new
      @role = Role.new
    end

    # GET /roles/1/edit
    def edit; end

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
    end

    def clone
      @role = Role.clone_record params[:role_id]
      if @role.save
        redirect_to admin_roles_path
      else
        render :new
      end
    end

    # DELETE /roles/1
    def destroy
      @role.destroy
      redirect_to admin_roles_path, notice: actions_messages(@role)
    end

    def destroy_multiple
      Role.destroy redefine_ids(params[:multiple_ids])
      redirect_to(
        admin_roles_path(page: @current_page, search: @query),
        notice: actions_messages(Role.new)
      )
    end

    def upload
      Role.upload(params[:file])
      redirect_to(
        admin_roles_path(page: @current_page, search: @query),
        notice: actions_messages(Role.new)
      )
    end

    def download
      @roles = Role.all
      respond_to do |format|
        format.html
        format.xls { send_data(@roles.to_xls) }
        format.json { render json: @roles }
      end
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

    private

    def set_attachments
      @attachments = %i[ logo brand photo avatar cover image
                         picture banner attachment pic file ]
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_role
      @role = Role.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def role_params
      params.require(:role).permit(:name, :role_id)
    end

    def authorization
      authorize Role
    end

    def show_history
      get_history(Role)
    end
  end
end
