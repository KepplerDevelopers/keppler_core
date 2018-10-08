require_dependency "keppler_languages/application_controller"
module KepplerLanguages
  module Admin
    # LanguagesController
    class LanguagesController < ::Admin::AdminController
      layout 'keppler_languages/admin/layouts/application'
      before_action :set_language, only: [:show, :edit, :update, :destroy]
      before_action :show_history, only: [:index]
      before_action :set_attachments
      before_action :authorization
      before_action :languages_names
      after_action :update_languages_yml, only: [:create, :update, :destroy, :destroy_multiple, :clone]
      after_action :update_fields_yml, only: [:create, :update, :destroy, :destroy_multiple, :clone]

      # include KepplerLanguages::Concerns::Commons
      # include KepplerLanguages::Concerns::History
      # include KepplerLanguages::Concerns::DestroyMultiple
      include KepplerLanguages::Concerns::Yml


      # GET /languages
      def index
        @q = Language.ransack(params[:q])
        languages = @q.result(distinct: true)
        @objects = languages.page(@current_page).order(position: :asc)
        @total = languages.size
        @languages = @objects.all
        if !@objects.first_page? && @objects.size.zero?
          redirect_to languages_path(page: @current_page.to_i.pred, search: @query)
        end
        respond_to do |format|
          format.html
          format.xls { send_data(@languages.to_xls) }
          format.json { render :json => @objects }
        end
      end

      # GET /languages/1
      def show
      end

      # GET /languages/new
      def new
        @language = Language.new
      end

      # GET /languages/1/edit
      def edit
      end

      # POST /languages
      def create
        @language = Language.new(language_params)

        if @language.save && @language.create_yml
          update_yml(@language.id)
          redirect_to admin_languages_languages_path(@language)
        else
          render :new
        end
      end

      # PATCH/PUT /languages/1
      def update
        @language.update_yml(language_params)
        update_fields(@language, params[:language][:fields_attributes].values)
        if @language.update(name: params[:language][:name])
          update_yml(@language.id)
          redirect_to admin_languages_languages_path
        else
          render :edit
        end
      end

      def destroy_field
        language = Language.find(params[:language_id])
        field = Field.find(params[:field_id])
        field.destroy

        update_yml(language.id)
        redirect_to edit_admin_languages_language_path(language)
      end

      def clone
        @language = Language.clone_record params[:language_id]

        if @language.save
          redirect_to admin_languages_languages_path
        else
          render :new
        end
      end

      # DELETE /languages/1
      def destroy
        if @language
          @language.destroy
        end
        redirect_to admin_languages_languages_path, notice: actions_messages(@language)
      end

      def destroy_multiple
        Language.destroy redefine_ids(params[:multiple_ids])
        redirect_to(
          admin_languages_languages_path(page: @current_page, search: @query),
          notice: actions_messages(Language.new)
        )
      end

      def upload
        Language.upload(params[:file])
        redirect_to(
          admin_languages_path(page: @current_page, search: @query),
          notice: actions_messages(Language.new)
        )
      end

      def download
        @languages = Language.all
        respond_to do |format|
          format.html
          format.xls { send_data(@languages.to_xls) }
          format.json { render json: @languages }
        end
      end

      def reload
        @q = Language.ransack(params[:q])
        languages = @q.result(distinct: true)
        @objects = languages.page(@current_page).order(position: :desc)
      end

      def sort
        Language.sorter(params[:row])
        @q = Language.ransack(params[:q])
        languages = @q.result(distinct: true)
        @objects = languages.page(@current_page)
        render :index
      end

      def toggle
        languages = Language.all
        language = Language.find(params[:language_id])
        languages.update_all(active: false)
        language.update(active: params[:language][:active])

        redirect_to admin_languages_languages_path
     end

      private

      def languages_names
        @names = YAML.load_file(
          "#{Rails.root}/rockets/keppler_languages/config/locales.yml"
        ).values.each(&:symbolize_keys!)
      end

      def update_fields(language, fields)
        language.fields.destroy_all unless fields.empty?
        fields.each do |field|
          language.fields.create(
            key: field['key'],
            value: field['value'],
          )
        end
      end

      def fields_attributes
        [:id, :key, :value, :_destroy]
      end

      def authorization
        authorize Language
      end

      def set_attachments
        @attachments = ['logo', 'brand', 'photo', 'avatar', 'cover', 'image',
                        'picture', 'banner', 'attachment', 'pic', 'file']
      end

      # Use callbacks to share common setup or constraints between actions.
      def set_language
        @language = Language.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def language_params
        params.require(:language).permit(
          :name,
          :position,
          :deleted_at,
          fields_attributes: fields_attributes,
        )
      end

      def show_history
        get_history(Language)
      end

      def get_history(model)
        @activities = PublicActivity::Activity.where(
          trackable_type: model.to_s
        ).order('created_at desc').limit(50)
      end
    end
  end
end
