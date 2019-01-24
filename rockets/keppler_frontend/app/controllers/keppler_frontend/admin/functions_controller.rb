require_dependency "keppler_frontend/application_controller"
module KepplerFrontend
  module Admin
    # FunctionsController
    class FunctionsController < ::Admin::AdminController
      layout 'keppler_frontend/admin/layouts/application'
      before_action :set_function, only: [:show, :edit, :update, :destroy]
      before_action :show_history, only: [:index]
      before_action :set_attachments
      before_action :authorization
      after_action :update_functions_yml, only: [:create, :update, :destroy, :destroy_multiple, :clone]
      after_action :update_parameters_yml, only: [:create, :update, :destroy, :destroy_multiple, :clone]
      # include KepplerFrontend::Concerns::Commons
      # include KepplerFrontend::Concerns::History
      # include KepplerFrontend::Concerns::DestroyMultiple
      include KepplerFrontend::Concerns::Yml

      # GET /functions
      def index
        @q = Function.ransack(params[:q])
        functions = @q.result(distinct: true)
        @objects = functions.page(@current_page).order(position: :asc)
        @total = functions.size
        @functions = @objects.all
        if !@objects.first_page? && @objects.size.zero?
          redirect_to functions_path(page: @current_page.to_i.pred, search: @query)
        end
        respond_to do |format|
          format.html
          format.xls { send_data(@functions.to_xls) }
          format.json { render :json => @objects }
        end
      end

      # GET /functions/1
      def show
      end

      # GET /functions/new
      def new
        @function = Function.new
      end

      # GET /functions/1/edit
      def edit
      end

      # POST /functions
      def create
        @function = Function.new(function_params)

        if @function.save && @function.create_function
          redirect(@function, params)
        else
          render :new
        end
      end

      # PATCH/PUT /functions/1
      def update
        old_name = @function.name
        update_params(@function, params[:function][:parameters_attributes].values)
        if @function.update(name: params[:function][:name])
          @function.update_function(old_name, @function)
          redirect(@function, params)
        else
          render :edit
        end
      end

      def update_params(function, params)
        function.parameters.destroy_all unless params.empty?
        params.each do |param|
          function.parameters.create(
            name: param['name'],
          )
        end
      end

      def clone
        @function = Function.clone_record params[:function_id]

        if @function.save
          redirect_to admin_frontend_functions_path
        else
          render :new
        end
      end

      # DELETE /functions/1
      def destroy
        @function.destroy
        redirect_to admin_frontend_functions_path, notice: actions_messages(@function)
      end

      def destroy_multiple
        Function.destroy redefine_ids(params[:multiple_ids])
        redirect_to(
          admin_frontend_functions_path(page: @current_page, search: @query),
          notice: actions_messages(Function.new)
        )
      end

      def upload
        Function.upload(params[:file])
        redirect_to(
          admin_functions_path(page: @current_page, search: @query),
          notice: actions_messages(Function.new)
        )
      end

      def download
        @functions = Function.all
        respond_to do |format|
          format.html
          format.xls { send_data(@functions.to_xls) }
          format.json { render json: @functions }
        end
      end

      def reload
        @q = Function.ransack(params[:q])
        functions = @q.result(distinct: true)
        @objects = functions.page(@current_page).order(position: :desc)
      end

      def sort
        Function.sorter(params[:row])
        @q = Function.ransack(params[:q])
        functions = @q.result(distinct: true)
        @objects = functions.page(@current_page)
        render :index
      end

      def editor_save
        @function = Function.find(params[:function_id])
        @function.save_function(params[:actions]) if params[:actions]
        render json: {result: true}
      end

      def destroy_param
        function = Function.find(params[:function_id])
        param = Parameter.find(params[:param_id])
        param.destroy

        function.update_function(function.name, function)
        redirect_to edit_admin_frontend_function_path(function)
      end

      private

      def parameters_attributes
        [:name]
      end

      def authorization
        authorize Function
      end

      def set_attachments
        @attachments = ['logo', 'brand', 'photo', 'avatar', 'cover', 'image',
                        'picture', 'banner', 'attachment', 'pic', 'file']
      end

      # Use callbacks to share common setup or constraints between actions.
      def set_function
        @function = Function.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def function_params
        params.require(:function).permit(
          :name,
          :description,
          :parameters,
          :position,
          :deleted_at,
          parameters_attributes: parameters_attributes
        )
      end

      def show_history
        get_history(Function)
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
