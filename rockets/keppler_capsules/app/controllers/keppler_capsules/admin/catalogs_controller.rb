require_dependency "keppler_capsules/application_controller"
module KepplerCapsules
  module Admin
    # CatalogsController
    class CatalogsController < ApplicationController
      layout 'keppler_capsules/admin/layouts/application'
      before_action :set_catalog, only: [:show, :edit, :update, :destroy]
      before_action :show_history, only: [:index]
      before_action :set_attachments
      before_action :authorization
      include KepplerCapsules::Concerns::Commons
      include KepplerCapsules::Concerns::History
      include KepplerCapsules::Concerns::DestroyMultiple


      # GET /catalogs
      def index
        @q = Catalog.ransack(params[:q])
        catalogs = @q.result(distinct: true)
        @objects = catalogs.page(@current_page).order(position: :asc)
        @total = catalogs.size
        @catalogs = @objects.all
        if !@objects.first_page? && @objects.size.zero?
          redirect_to catalogs_path(page: @current_page.to_i.pred, search: @query)
        end
        respond_to do |format|
          format.html
          format.xls { send_data(@catalogs.to_xls) }
          format.json { render :json => @objects }
        end
      end

      # GET /catalogs/1
      def show
      end

      # GET /catalogs/new
      def new
        @catalog = Catalog.new
      end

      # GET /catalogs/1/edit
      def edit
      end

      # POST /catalogs
      def create
        @catalog = Catalog.new(catalog_params)

        if @catalog.save
          redirect(@catalog, params)
        else
          render :new
        end
      end

      # PATCH/PUT /catalogs/1
      def update
        if @catalog.update(catalog_params)
          redirect(@catalog, params)
        else
          render :edit
        end
      end

      def clone
        @catalog = Catalog.clone_record params[:catalog_id]

        if @catalog.save
          redirect_to admin_capsules_catalogs_path
        else
          render :new
        end
      end

      # DELETE /catalogs/1
      def destroy
        @catalog.destroy
        redirect_to admin_capsules_catalogs_path, notice: actions_messages(@catalog)
      end

      def destroy_multiple
        Catalog.destroy redefine_ids(params[:multiple_ids])
        redirect_to(
          admin_catalogs_path(page: @current_page, search: @query),
          notice: actions_messages(Catalog.new)
        )
      end

      def upload
        Catalog.upload(params[:file])
        redirect_to(
          admin_catalogs_path(page: @current_page, search: @query),
          notice: actions_messages(Catalog.new)
        )
      end

      def download
        @catalogs = Catalog.all
        respond_to do |format|
          format.html
          format.xls { send_data(@catalogs.to_xls) }
          format.json { render json: @catalogs }
        end
      end

      def reload
        @q = Catalog.ransack(params[:q])
        catalogs = @q.result(distinct: true)
        @objects = catalogs.page(@current_page).order(position: :desc)
      end

      def sort
        Catalog.sorter(params[:row])
        @q = Catalog.ransack(params[:q])
        catalogs = @q.result(distinct: true)
        @objects = catalogs.page(@current_page)
        render :index
      end

      private

      def authorization
        authorize Catalog
      end

      def set_attachments
        @attachments = ['logo', 'brand', 'photo', 'avatar', 'cover', 'image',
                        'picture', 'banner', 'attachment', 'pic', 'file']
      end

      # Use callbacks to share common setup or constraints between actions.
      def set_catalog
        @catalog = Catalog.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def catalog_params
        params.require(:catalog).permit(:photo, :name, :description, :position, :deleted_at)
      end

      def show_history
        get_history(Catalog)
      end

      def get_history(model)
        @activities = PublicActivity::Activity.where(
          trackable_type: model.to_s
        ).order('created_at desc').limit(50)
      end

      # Get submit key to redirect, only [:create, :update]
      def redirect(object, commit)
        if commit.key?('_save')
          redirect_to([:admin, :capsules, object], notice: actions_messages(object))
        elsif commit.key?('_add_other')
          redirect_to(
            send("new_admin_capsules_#{underscore(object)}_path"),
            notice: actions_messages(object)
          )
        end
      end
    end
  end
end
