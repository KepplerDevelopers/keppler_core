require_dependency "keppler_languages/application_controller"
module KepplerLanguages
  module Admin
    # LanguagesController
    class LanguagesController < ApplicationController
      layout 'keppler_languages/admin/layouts/application'
      before_action :set_language, only: [:show, :edit, :update, :destroy]
      before_action :show_history, only: [:index]
      before_action :set_attachments
      before_action :authorization
      include KepplerLanguages::Concerns::Commons
      include KepplerLanguages::Concerns::History
      include KepplerLanguages::Concerns::DestroyMultiple


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
          redirect_to admin_languages_language_add_fields_path(@language)
        else
          render :new
        end
      end

      # PATCH/PUT /languages/1
      def update
        @language.update_yml(language_params)
        if @language.update(language_params)
          redirect(@language, params)
        else
          render :edit
        end
      end

      def add_fields
        @language = Language.find(params[:language_id])
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
          @language.delete_yml
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

      private

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
        params.require(:language).permit(:name, :position, :deleted_at)
      end

      def show_history
        get_history(Language)
      end

      def get_history(model)
        @activities = PublicActivity::Activity.where(
          trackable_type: model.to_s
        ).order('created_at desc').limit(50)
      end

      # Get submit key to redirect, only [:create, :update]
      def redirect(object, commit)
        if commit.key?('_save')
          redirect_to([:admin, :languages, object], notice: actions_messages(object))
        elsif commit.key?('_add_other')
          redirect_to(
            send("new_admin_languages_#{underscore(object)}_path"),
            notice: actions_messages(object)
          )
        end
      end
    end
  end
end
