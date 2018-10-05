require_dependency "keppler_frontend/application_controller"
module KepplerFrontend
  module Admin
    # ViewsController
    class ViewsController < ::Admin::AdminController
      layout 'keppler_frontend/admin/layouts/application'
      before_action :set_view, only: [:show, :edit, :update, :destroy]
      before_action :show_history, only: [:index]
      before_action :set_attachments
      before_action :authorization
      before_action :only_development
      before_action :reload_views, only: [:index]
      after_action :update_view_yml, only: [:create, :update, :destroy, :destroy_multiple, :clone]
      before_action :reload_view_callbacks, only: [:index]
      after_action :update_view_callback_yml, only: [:create, :update, :destroy, :destroy_multiple, :clone]
      # include KepplerFrontend::Concerns::Commons
      # include KepplerFrontend::Concerns::History
      # include KepplerFrontend::Concerns::DestroyMultiple
      include KepplerFrontend::Concerns::Grapesjs

      skip_before_action :verify_authenticity_token, only: :live_editor_save


      # GET /views
      def index
        @q = View.ransack(params[:q])
        views = @q.result(distinct: true)
        @objects = views.page(@current_page).where.not(name: 'keppler').order(position: :asc)
        @total = views.size
        @views = @objects.all
        if !@objects.first_page? && @objects.size.zero?
          redirect_to views_path(page: @current_page.to_i.pred, search: @query)
        end
        respond_to do |format|
          format.html
          format.xls { send_data(@views.to_xls) }
          format.json { render :json => @objects }
        end
      end

      # GET /views/1
      def show
      end

      # GET /views/new
      def new
        @view = View.new
      end

      # GET /views/1/edit
      def edit
      end

      # POST /views
      def create
        @view = View.new(view_params)

        if @view.save && @view.install
          redirect_to admin_frontend_view_editor_path(@view), notice: actions_messages(@view)
        else
          render :new
        end
      end

      # PATCH/PUT /views/1
      def update
        @view.delete_route
        @view.update_files(view_params)
        if @view.update(view_params)
          view = view_params.to_h
          @view.new_callback(@view, view[:view_callbacks_attributes])
          redirect_to edit_admin_frontend_view_path(@view), notice: actions_messages(@view)
        else
          render :edit
        end
        @view.add_route
      end

      def clone
        @view = View.clone_record params[:view_id]

        if @view.save
          redirect_to admin_frontend_views_path
        else
          render :new
        end
      end

      # DELETE /views/1
      def destroy
        if @view
          @view.uninstall
          @view.destroy
        end
        redirect_to admin_frontend_views_path, notice: actions_messages(@view)
      end

      def destroy_callback
        @view = View.find(params[:view_id])
        @callback = ViewCallback.find(params[:view_callback_id])
        @callback.destroy
      end

      def destroy_multiple
        View.destroy redefine_ids(params[:multiple_ids])
        redirect_to(
          admin_frontend_views_path(page: @current_page, search: @query),
          notice: actions_messages(View.new)
        )
      end

      def upload
        View.upload(params[:file])
        redirect_to(
          admin_frontend_views_path(page: @current_page, search: @query),
          notice: actions_messages(View.new)
        )
      end

      def sort
        View.sorter(params[:row])
        @q = View.ransack(params[:q])
        views = @q.result(distinct: true)
        @objects = views.page(@current_page)
        render :index
      end

      def editor
        @view = View.find(params[:view_id])
        filesystem = FileUploadSystem.new
        @files_list = filesystem.files_list 
        @files_views = filesystem.files_list_custom('views')
        @partials = Partial.all
        @views = View.where.not(name: 'keppler').order(position: :asc)
        @functions = KepplerFrontend::Function.all
      end

      def editor_save
        @view = View.find(params[:view_id])
        @view.code_save(params[:html], 'html') if params[:html]
        @view.code_save(params[:scss], 'scss') if params[:scss]
        @view.code_save(params[:js], 'js') if params[:js]
        @view.code_save(params[:js_erb], 'js_erb') if params[:js_erb]
        @view.code_save(params[:ruby], 'action') if params[:ruby]
        render json: {result: true}
      end

      def select_theme_view
        @view = View.where(id: params[:view_id]).first
        theme_view=File.readlines("#{url_front}/app/assets/html/keppler_frontend/views/#{params[:theme_view]}.html")
        theme_view = theme_view.join
        out_file = File.open("#{url_front}/app/views/keppler_frontend/app/frontend/#{@view.name}.html.erb", "w")
        out_file.puts("<keppler-view id='#{@view.name}'>\n  #{theme_view}\n</keppler-view>");
        out_file.close
        redirect_to admin_frontend_view_editor_path(params[:view_id])
      end

      def live_editor_save
        result = save_grapesjs_code(
          params[:view_id], 
          params[:html], 
          params[:css]
        )
        render json: { result: result}
      end

      private

      def authorization
        authorize View
      end

      def url_front
        "#{Rails.root}/rockets/keppler_frontend"
      end

      def reload_views
        file =  File.join("#{Rails.root}/rockets/keppler_frontend/config/views.yml")
        routes = YAML.load_file(file)
        routes.each do |route|
          view = KepplerFrontend::View.where(url: route['url']).first
          unless view
            KepplerFrontend::View.create(
              name: route['name'],
              url: route['url'],
              method: route['method'],
              active: route['active'],
              format_result: route['format_result']
            )
          end
        end
      end

      def update_view_yml
        views = View.all
        file =  File.join("#{Rails.root}/rockets/keppler_frontend/config/views.yml")
        data = views.as_json.to_yaml
        File.write(file, data)
      end

      def reload_view_callbacks
        file =  File.join("#{Rails.root}/rockets/keppler_frontend/config/view_callbacks.yml")
        view_callbacks = YAML.load_file(file)
        view_callbacks.each do |route|
          callback = KepplerFrontend::ViewCallback.where(name: route['name']).first
          unless callback
            KepplerFrontend::ViewCallback.create(
              name: route['name'],
              function_type: route['function_type']
            )
          end
        end
      end

      def update_view_callback_yml
        view_callbacks = ViewCallback.all
        file =  File.join("#{Rails.root}/rockets/keppler_frontend/config/view_callbacks.yml")
        data = view_callbacks.as_json.to_yaml
        File.write(file, data)
      end

      def set_attachments
        @attachments = ['logo', 'brand', 'photo', 'avatar', 'cover', 'image',
                        'picture', 'banner', 'attachment', 'pic', 'file']
      end

      # Use callbacks to share common setup or constraints between actions.
      def set_view
        @view = View.where(id: params[:id]).first
      end

      # Only allow a trusted parameter "white list" through.
      def view_params
        params.require(:view).permit(:name, :url, :root_path, :method, :active, :format_result, :position, :deleted_at,
                                     view_callbacks_attributes: view_callbacks_attributes)
      end

      def view_callbacks_attributes
        [:name, :function_type, :_destroy]
      end

      def redefine_ids(ids)
        ids.delete('[]').split(',').select do |id|
          View.find(id).uninstall if model.exists? id
          id if model.exists? id
        end
      end

      def show_history
        get_history(View)
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
