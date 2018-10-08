require_dependency "keppler_frontend/application_controller"
module KepplerFrontend
  module Admin
    # ThemesController
    class ThemesController < ::Admin::AdminController
      layout 'keppler_frontend/admin/layouts/application'
      before_action :set_theme, only: [:show, :edit, :update, :destroy]
      before_action :show_history, only: [:index]
      before_action :set_attachments
      before_action :authorization
      before_action :only_development
      before_action :reload_themes, only: [:index]
      after_action :update_theme_yml, only: [:create, :update, :destroy, :destroy_multiple, :clone]
      # include KepplerFrontend::Concerns::Commons
      # include KepplerFrontend::Concerns::History
      # include KepplerFrontend::Concerns::DestroyMultiple


      # GET /themes
      def index
        @q = Theme.ransack(params[:q])
        themes = @q.result(distinct: true)
        @objects = themes.page(@current_page).order(position: :asc)
        @total = themes.size
        @themes = @objects.all
        @theme = Theme.where(active: true).first
        if !@objects.first_page? && @objects.size.zero?
          redirect_to themes_path(page: @current_page.to_i.pred, search: @query)
        end
        respond_to do |format|
          format.html
          format.xls { send_data(@themes.to_xls) }
          format.json { render :json => @objects }
        end
      end

      # GET /themes/1
      def show
      end

      # GET /themes/new
      def new
        @theme = Theme.new
      end

      # GET /themes/1/edit
      def edit
      end

      # POST /themes
      def create
        @theme = Theme.new(theme_params)
        @theme.name = name_format(params[:theme][:file])
        @theme.active = false
        uploader = ImgFileUploader.new

        File.open(params[:theme][:file].path) do |file|
          uploader.store!(file)
        end

        if @theme.validate_theme(uploader, params[:theme][:file])
          @theme.save
          @theme.install(params[:theme][:file])
          redirect_to(
            admin_frontend_themes_path(page: @current_page, search: @query),
            notice: t("keppler_frontend.theme.success")
          )
        else
          flash[:notice] = t("keppler_frontend.theme.fail")
          render :new
        end
      end

      # PATCH/PUT /themes/1
      def update
        if params[:theme][:active].eql?('true')
          @theme.desactived
          change_all_to_false
          if @theme.update(theme_params)
            @theme.actived
          else
            render :edit
          end
        end
        redirect_to(
          admin_frontend_themes_path(page: @current_page, search: @query),
          notice: t("keppler_frontend.theme.apply")
        )
      end

      def clone
        @theme = Theme.clone_record params[:theme_id]

        if @theme.save
          redirect_to admin_frontend_themes_path
        else
          render :new
        end
      end

      # DELETE /themes/1
      def destroy
        @theme.destroy if @theme && @theme.active.eql?(false)
        redirect_to admin_frontend_themes_path, notice: actions_messages(@theme)
      end

      def destroy_multiple
        Theme.destroy redefine_ids(params[:multiple_ids])
        redirect_to(
          admin_frontend_themes_path(page: @current_page, search: @query),
          notice: actions_messages(Theme.new)
        )
      end

      def upload
        Theme.upload(params[:file])
        redirect_to(
          admin_themes_path(page: @current_page, search: @query),
          notice: actions_messages(Theme.new)
        )
      end

      def download
        @themes = Theme.all
        respond_to do |format|
          format.html
          format.xls { send_data(@themes.to_xls) }
          format.json { render json: @themes }
        end
      end

      def reload
        @q = Theme.ransack(params[:q])
        themes = @q.result(distinct: true)
        @objects = themes.page(@current_page).order(position: :desc)
      end

      def sort
        Theme.sorter(params[:row])
        @q = Theme.ransack(params[:q])
        themes = @q.result(distinct: true)
        @objects = themes.page(@current_page)
        render :index
      end

      def show_covers
        @theme = Theme.find(params[:theme_id])
      end

      def editor
        @theme = Theme.find(params[:theme_id])
        filesystem = FileUploadSystem.new
        @files_list = filesystem.files_list + filesystem.files_list_custom("bootstrap")
        @partials = Partial.all
      end

      def editor_save
        @theme = Theme.find(params[:theme_id])
        @theme.save_head(params[:head]) if params[:head]
        @theme.save_header(params[:header]) if params[:header]
        @theme.save_footer(params[:footer]) if params[:footer]
        render json: {result: true}
      end

      private

      def authorization
        authorize Theme
      end

      def reload_themes
        file =  File.join("#{Rails.root}/rockets/keppler_frontend/config/themes.yml")
        themes = YAML.load_file(file)
        if themes
          themes.each do |theme|
            theme_db = KepplerFrontend::Theme.where(name: theme['name']).first
            unless theme_db
              KepplerFrontend::Theme.create(
                name: theme['name'],
                active: theme['active']
              )
            end
          end
        end
      end

      def change_all_to_false
        Theme.all.each { |t| t.update(active: false) }
      end

      def name_format(file)
        file.original_filename.split('.').first.downcase.gsub(' ', '_').gsub('-', '_')
      end

      def update_theme_yml
        themes = Theme.all
        file =  File.join("#{Rails.root}/rockets/keppler_frontend/config/themes.yml")
        data = themes.as_json.to_yaml
        File.write(file, data)
      end


      def set_attachments
        @attachments = ['logo', 'brand', 'photo', 'avatar', 'cover', 'image',
                        'picture', 'banner', 'attachment', 'pic', 'file']
      end

      # Use callbacks to share common setup or constraints between actions.
      def set_theme
        @theme = Theme.where(id: params[:id]).first
      end

      # Only allow a trusted parameter "white list" through.
      def theme_params
        params.require(:theme).permit(:name, :active, :position, :deleted_at)
      end

      def show_history
        get_history(Theme)
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
