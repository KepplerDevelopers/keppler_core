require_dependency "keppler_frontend/application_controller"
module KepplerFrontend
  module Admin
    # ViewsController
    class ViewsController < ApplicationController
      layout 'keppler_frontend/admin/layouts/application'
      before_action :set_view, only: [:show, :edit, :update, :destroy]
      before_action :show_history, only: [:index]
      before_action :set_attachments
      before_action :authorization
      after_action :update_view_yml, only: [:create, :update, :destroy, :destroy_multiple, :clone]
      include KepplerFrontend::Concerns::Commons
      include KepplerFrontend::Concerns::History
      include KepplerFrontend::Concerns::DestroyMultiple


      # GET /views
      def index
        @q = View.ransack(params[:q])
        views = @q.result(distinct: true)
        @objects = views.page(@current_page).order(position: :asc)
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
          redirect(@view, params)
        else
          render :new
        end
      end

      # PATCH/PUT /views/1
      def update
        @view.delete_route
        @view.update_action(view_params)
        @view.update_html(view_params)
        if @view.update(view_params)
          @view.add_route
          redirect(@view, params)
        else
          render :edit
        end
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
        @view.uninstall
        @view.destroy
        redirect_to admin_frontend_views_path, notice: actions_messages(@view)
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

      def download
        @views = View.all
        respond_to do |format|
          format.html
          format.xls { send_data(@views.to_xls) }
          format.json { render json: @views }
        end
      end

      def reload
        @q = View.ransack(params[:q])
        views = @q.result(distinct: true)
        @objects = views.page(@current_page).order(position: :desc)
      end

      def sort
        View.sorter(params[:row])
        @q = View.ransack(params[:q])
        views = @q.result(distinct: true)
        @objects = views.page(@current_page)
        render :index
      end

      def editor; end

      private

      def authorization
        authorize View
      end

      def update_view_yml
        views = View.all
        file =  File.join("#{Rails.root}/rockets/keppler_frontend/config/views.yml")
        data = views.as_json.to_yaml
        File.write(file, data)
      end

      def set_attachments
        @attachments = ['logo', 'brand', 'photo', 'avatar', 'cover', 'image',
                        'picture', 'banner', 'attachment', 'pic', 'file']
      end

      # Use callbacks to share common setup or constraints between actions.
      def set_view
        @view = View.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def view_params
        params.require(:view).permit(:name, :url, :root_path, :method, :active, :format_result, :position, :deleted_at)
      end

      def redefine_ids(ids)
        ids.delete('[]').split(',').select do |id|
          View.find(id).uninstall
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
