require_dependency "keppler_frontend/application_controller"
module KepplerFrontend
  module Admin
    # CallbackFunctionsController
    class CallbackFunctionsController < ::Admin::AdminController
      layout 'keppler_frontend/admin/layouts/application'
      before_action :set_callback_function, only: [:show, :edit, :update, :destroy]
      before_action :show_history, only: [:index]
      before_action :set_attachments
      before_action :reload_callbacks, only: [:index]
      after_action :update_callback_yml, only: [:create, :update, :destroy, :destroy_multiple, :clone]
      before_action :authorization
      # include KepplerFrontend::Concerns::Commons
      # include KepplerFrontend::Concerns::History
      # include KepplerFrontend::Concerns::DestroyMultiple
      include KepplerFrontend::Concerns::Services


      # GET /callback_functions
      def index
        @q = CallbackFunction.ransack(params[:q])
        callback_functions = @q.result(distinct: true)
        @objects = callback_functions.page(@current_page).order(position: :asc)
        @total = callback_functions.size
        @callback_functions = @objects.all
        if !@objects.first_page? && @objects.size.zero?
          redirect_to callback_functions_path(page: @current_page.to_i.pred, search: @query)
        end
        respond_to do |format|
          format.html
          format.xls { send_data(@callback_functions.to_xls) }
          format.json { render :json => @objects }
        end
      end

      # GET /callback_functions/1
      def show
      end

      # GET /callback_functions/new
      def new
        @callback_function = CallbackFunction.new
      end

      # GET /callback_functions/1/edit
      def edit
      end

      # POST /callback_functions
      def create
        @callback_function = CallbackFunction.new(callback_function_params)

        if @callback_function.save && @callback_function.install
          redirect_to(
            admin_frontend_callback_function_editor_path(@callback_function),
            notice: actions_messages(@callback_function)
          )
        else
          render :new
        end
      end

      # PATCH/PUT /callback_functions/1
      def update
        @callback_function.change_name(callback_function_params[:name])
        if @callback_function.update(callback_function_params)
          redirect(@callback_function, params)
        else
          render :edit
        end
      end

      def clone
        @callback_function = CallbackFunction.clone_record params[:callback_function_id]

        if @callback_function.save
          redirect_to admin_frontend_callback_functions_path
        else
          render :new
        end
      end

      # DELETE /callback_functions/1
      def destroy
        @callback_function.destroy
        redirect_to admin_frontend_callback_functions_path, notice: actions_messages(@callback_function)
      end

      def destroy_multiple
        CallbackFunction.destroy redefine_ids(params[:multiple_ids])
        redirect_to(
          admin_frontend_callback_functions_path(page: @current_page, search: @query),
          notice: actions_messages(CallbackFunction.new)
        )
      end

      def upload
        CallbackFunction.upload(params[:file])
        redirect_to(
          admin_callback_functions_path(page: @current_page, search: @query),
          notice: actions_messages(CallbackFunction.new)
        )
      end

      def download
        @callback_functions = CallbackFunction.all
        respond_to do |format|
          format.html
          format.xls { send_data(@callback_functions.to_xls) }
          format.json { render json: @callback_functions }
        end
      end

      def reload
        @q = CallbackFunction.ransack(params[:q])
        callback_functions = @q.result(distinct: true)
        @objects = callback_functions.page(@current_page).order(position: :desc)
      end

      def sort
        CallbackFunction.sorter(params[:row])
        @q = CallbackFunction.ransack(params[:q])
        callback_functions = @q.result(distinct: true)
        @objects = callback_functions.page(@current_page)
        render :index
      end

      def editor
        @callback_function = CallbackFunction.find(params[:callback_function_id])
        @views = View.all
      end

      def editor_save
        @callback_function = CallbackFunction.find(params[:callback_function_id])
        @callback_function.code_save(params[:actions])
        render json: {result: true}
      end

      private

      def authorization
        authorize CallbackFunction
      end

      def set_attachments
        @attachments = ['logo', 'brand', 'photo', 'avatar', 'cover', 'image',
                        'picture', 'banner', 'attachment', 'pic', 'file']
      end

      def reload_callbacks
        yml = yml_handler.new('callback_functions')
        yml.reload
      end

      def update_callback_yml
        callbacks = CallbackFunction.all
        yml = yml_handler.new('callback_functions', callbacks)
        yml.update
      end

      # Use callbacks to share common setup or constraints between actions.
      def set_callback_function
        @callback_function = CallbackFunction.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def callback_function_params
        params.require(:callback_function).permit(:name, :description, :position, :deleted_at)
      end

      def show_history
        get_history(CallbackFunction)
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
