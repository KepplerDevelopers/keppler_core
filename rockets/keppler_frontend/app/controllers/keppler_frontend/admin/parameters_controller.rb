require_dependency "keppler_frontend/application_controller"
module KepplerFrontend
  module Admin
    # ParametersController
    class ParametersController < ::Admin::AdminController
      layout 'keppler_frontend/admin/layouts/application'
      before_action :set_parameter, only: [:show, :edit, :update, :destroy]
      before_action :show_history, only: [:index]
      before_action :set_attachments
      before_action :authorization
      # include KepplerFrontend::Concerns::Commons
      # include KepplerFrontend::Concerns::History
      # include KepplerFrontend::Concerns::DestroyMultiple


      # GET /parameters
      def index
        @q = Parameter.ransack(params[:q])
        parameters = @q.result(distinct: true)
        @objects = parameters.page(@current_page).order(position: :asc)
        @total = parameters.size
        @parameters = @objects.all
        if !@objects.first_page? && @objects.size.zero?
          redirect_to parameters_path(page: @current_page.to_i.pred, search: @query)
        end
        respond_to do |format|
          format.html
          format.xls { send_data(@parameters.to_xls) }
          format.json { render :json => @objects }
        end
      end

      # GET /parameters/1
      def show
      end

      # GET /parameters/new
      def new
        @parameter = Parameter.new
      end

      # GET /parameters/1/edit
      def edit
      end

      # POST /parameters
      def create
        @parameter = Parameter.new(parameter_params)

        if @parameter.save
          redirect(@parameter, params)
        else
          render :new
        end
      end

      # PATCH/PUT /parameters/1
      def update
        if @parameter.update(parameter_params)
          redirect(@parameter, params)
        else
          render :edit
        end
      end

      def clone
        @parameter = Parameter.clone_record params[:parameter_id]

        if @parameter.save
          redirect_to admin_frontend_parameters_path
        else
          render :new
        end
      end

      # DELETE /parameters/1
      def destroy
        @parameter.destroy
        redirect_to admin_frontend_parameters_path, notice: actions_messages(@parameter)
      end

      def destroy_multiple
        Parameter.destroy redefine_ids(params[:multiple_ids])
        redirect_to(
          admin_parameters_path(page: @current_page, search: @query),
          notice: actions_messages(Parameter.new)
        )
      end

      def upload
        Parameter.upload(params[:file])
        redirect_to(
          admin_parameters_path(page: @current_page, search: @query),
          notice: actions_messages(Parameter.new)
        )
      end

      def download
        @parameters = Parameter.all
        respond_to do |format|
          format.html
          format.xls { send_data(@parameters.to_xls) }
          format.json { render json: @parameters }
        end
      end

      def reload
        @q = Parameter.ransack(params[:q])
        parameters = @q.result(distinct: true)
        @objects = parameters.page(@current_page).order(position: :desc)
      end

      def sort
        Parameter.sorter(params[:row])
        @q = Parameter.ransack(params[:q])
        parameters = @q.result(distinct: true)
        @objects = parameters.page(@current_page)
        render :index
      end

      private

      def authorization
        authorize Parameter
      end

      def set_attachments
        @attachments = ['logo', 'brand', 'photo', 'avatar', 'cover', 'image',
                        'picture', 'banner', 'attachment', 'pic', 'file']
      end

      # Use callbacks to share common setup or constraints between actions.
      def set_parameter
        @parameter = Parameter.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def parameter_params
        params.require(:parameter).permit(:name, :position, :deleted_at)
      end

      def show_history
        get_history(Parameter)
      end

      def get_history(model)
        @activities = PublicActivity::Activity.where(
          trackable_type: model.to_s
        ).order('created_at desc').limit(50)
      end

      # Get submit key to redirect, only [:create, :update]
      def redirect(object, commit)
        if commit.key?('_save')
          redirect_to([:admin, :frontend, object], notice: actions_messages(object))
        elsif commit.key?('_add_other')
          redirect_to(
            send("new_admin_frontend_#{underscore(object)}_path"),
            notice: actions_messages(object)
          )
        end
      end
    end
  end
end
