require_dependency "keppler_frontend/application_controller"
module KepplerFrontend
  module Admin
    # PartialsController
    class PartialsController < ::Admin::AdminController
      layout 'keppler_frontend/admin/layouts/application'
      before_action :set_partial, only: [:show, :edit, :update, :destroy]
      before_action :show_history, only: [:index]
      before_action :set_attachments
      before_action :authorization
      after_action :update_partials_yml, only: [:create, :update, :destroy, :destroy_multiple, :clone]
      # include KepplerFrontend::Concerns::Commons
      # include KepplerFrontend::Concerns::History
      # include KepplerFrontend::Concerns::DestroyMultiple


      # GET /partials
      def index
        @q = Partial.ransack(params[:q])
        partials = @q.result(distinct: true)
        @objects = partials.page(@current_page).order(position: :asc)
        @total = partials.size
        @partials = @objects.all
        if !@objects.first_page? && @objects.size.zero?
          redirect_to partials_path(page: @current_page.to_i.pred, search: @query)
        end
        respond_to do |format|
          format.html
          format.xls { send_data(@partials.to_xls) }
          format.json { render :json => @objects }
        end
      end

      # GET /partials/1
      def show
        filesystem = FileUploadSystem.new
        @files_list = filesystem.files_list + filesystem.files_list_custom("bootstrap")
      end

      # GET /partials/new
      def new
        @partial = Partial.new
      end

      # GET /partials/1/edit
      def edit; end

      def editor; end

      def editor_save
        @partial = Partial.find(params[:partial_id])
        @partial.code_save(params[:html], 'html') if params[:html]
        @partial.code_save(params[:scss], 'scss') if params[:scss]
        @partial.code_save(params[:js], 'js') if params[:js]
        render json: {result: true}
      end

      # POST /partials
      def create
        @partial = Partial.new(partial_params)

        if @partial.save && @partial.install
          redirect(@partial, params)
        else
          render :new
        end
      end

      # PATCH/PUT /partials/1
      def update
        @partial.update_files(partial_params)
        if @partial.update(partial_params)
          redirect(@partial, params)
        else
          render :edit
        end
      end

      def clone
        @partial = Partial.clone_record params[:partial_id]

        if @partial.save
          redirect_to admin_frontend_partials_path
        else
          render :new
        end
      end

      # DELETE /partials/1
      def destroy
        @partial.uninstall
        @partial.destroy

        redirect_to admin_frontend_partials_path, notice: actions_messages(@partial)
      end

      def destroy_multiple
        Partial.destroy redefine_ids(params[:multiple_ids])
        redirect_to(
          admin_frontend_partials_path(page: @current_page, search: @query),
          notice: actions_messages(Partial.new)
        )
      end

      def upload
        Partial.upload(params[:file])
        redirect_to(
          admin_partials_path(page: @current_page, search: @query),
          notice: actions_messages(Partial.new)
        )
      end

      def download
        @partials = Partial.all
        respond_to do |format|
          format.html
          format.xls { send_data(@partials.to_xls) }
          format.json { render json: @partials }
        end
      end

      def reload
        @q = Partial.ransack(params[:q])
        partials = @q.result(distinct: true)
        @objects = partials.page(@current_page).order(position: :desc)
      end

      def sort
        Partial.sorter(params[:row])
        @q = Partial.ransack(params[:q])
        partials = @q.result(distinct: true)
        @objects = partials.page(@current_page)
        render :index
      end

      private

      def update_partials_yml
        partials = KepplerFrontend::Partial.all
        file =  File.join("#{Rails.root}/rockets/keppler_frontend/config/partials.yml")
        data = partials.as_json.to_yaml
        File.write(file, data)
      end

      def authorization
        authorize Partial
      end

      def set_attachments
        @attachments = ['logo', 'brand', 'photo', 'avatar', 'cover', 'image',
                        'picture', 'banner', 'attachment', 'pic', 'file']
      end

      # Use callbacks to share common setup or constraints between actions.
      def set_partial
        @partial = Partial.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def partial_params
        params.require(:partial).permit(:name, :position, :deleted_at)
      end

      def show_history
        get_history(Partial)
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
