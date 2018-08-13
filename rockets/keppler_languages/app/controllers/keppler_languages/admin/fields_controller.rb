require_dependency "keppler_languages/application_controller"
module KepplerLanguages
  module Admin
    # FieldsController
    class FieldsController < ApplicationController
      layout 'keppler_languages/admin/layouts/application'
      before_action :set_field, only: [:show, :edit, :update, :destroy]
      before_action :show_history, only: [:index]
      before_action :set_attachments
      before_action :authorization
      include KepplerLanguages::Concerns::Commons
      include KepplerLanguages::Concerns::History
      include KepplerLanguages::Concerns::DestroyMultiple


      # GET /fields
      def index
        @q = Field.ransack(params[:q])
        fields = @q.result(distinct: true)
        @objects = fields.page(@current_page).order(position: :asc)
        @total = fields.size
        @fields = @objects.all
        if !@objects.first_page? && @objects.size.zero?
          redirect_to fields_path(page: @current_page.to_i.pred, search: @query)
        end
        respond_to do |format|
          format.html
          format.xls { send_data(@fields.to_xls) }
          format.json { render :json => @objects }
        end
      end

      # GET /fields/1
      def show
      end

      # GET /fields/new
      def new
        @field = Field.new
      end

      # GET /fields/1/edit
      def edit
      end

      # POST /fields
      def create
        @field = Field.new(field_params)

        if @field.save
          redirect(@field, params)
        else
          render :new
        end
      end

      # PATCH/PUT /fields/1
      def update
        if @field.update(field_params)
          redirect(@field, params)
        else
          render :edit
        end
      end

      def clone
        @field = Field.clone_record params[:field_id]

        if @field.save
          redirect_to admin_languages_fields_path
        else
          render :new
        end
      end

      # DELETE /fields/1
      def destroy
        @field.destroy
        redirect_to admin_languages_fields_path, notice: actions_messages(@field)
      end

      def destroy_multiple
        Field.destroy redefine_ids(params[:multiple_ids])
        redirect_to(
          admin_fields_path(page: @current_page, search: @query),
          notice: actions_messages(Field.new)
        )
      end

      def upload
        Field.upload(params[:file])
        redirect_to(
          admin_fields_path(page: @current_page, search: @query),
          notice: actions_messages(Field.new)
        )
      end

      def download
        @fields = Field.all
        respond_to do |format|
          format.html
          format.xls { send_data(@fields.to_xls) }
          format.json { render json: @fields }
        end
      end

      def reload
        @q = Field.ransack(params[:q])
        fields = @q.result(distinct: true)
        @objects = fields.page(@current_page).order(position: :desc)
      end

      def sort
        Field.sorter(params[:row])
        @q = Field.ransack(params[:q])
        fields = @q.result(distinct: true)
        @objects = fields.page(@current_page)
        render :index
      end

      private

      def authorization
        authorize Field
      end

      def set_attachments
        @attachments = ['logo', 'brand', 'photo', 'avatar', 'cover', 'image',
                        'picture', 'banner', 'attachment', 'pic', 'file']
      end

      # Use callbacks to share common setup or constraints between actions.
      def set_field
        @field = Field.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def field_params
        params.require(:field).permit(:key, :value, :position, :deleted_at)
      end

      def show_history
        get_history(Field)
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
