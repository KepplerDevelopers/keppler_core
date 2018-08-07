require_dependency "keppler_capsules/application_controller"
module KepplerCapsules
  module Admin
    # CapsulesController
    class CapsulesController < ApplicationController
      layout 'keppler_capsules/admin/layouts/application'
      before_action :set_capsule, only: [:show, :edit, :update, :destroy]
      before_action :show_history, only: [:index]
      before_action :set_attachments
      before_action :authorization
      before_action :reload_capsules, only: [:index]
      after_action :update_capsules_yml, only: [:create, :update, :destroy, :destroy_multiple, :clone]
      before_action :reload_capsule_fields, only: [:index]
      after_action :update_capsule_fields_yml, only: [:create, :update, :destroy, :destroy_multiple, :clone]
      before_action :reload_capsule_validations, only: [:index]
      after_action :update_capsule_validations_yml, only: [:create, :update, :destroy, :destroy_multiple, :clone]
      include KepplerCapsules::Concerns::Commons
      include KepplerCapsules::Concerns::History
      include KepplerCapsules::Concerns::DestroyMultiple
      include KepplerCapsules::Concerns::YmlSave


      # GET /capsules
      def index
        @q = Capsule.ransack(params[:q])
        capsules = @q.result(distinct: true)
        @objects = capsules.page(@current_page).order(position: :asc)
        @total = capsules.size
        @capsules = @objects.all
        if !@objects.first_page? && @objects.size.zero?
          redirect_to capsules_path(page: @current_page.to_i.pred, search: @query)
        end
        respond_to do |format|
          format.html
          format.xls { send_data(@capsules.to_xls) }
          format.json { render :json => @objects }
        end
      end

      # GET /capsules/1
      def show
      end

      # GET /capsules/new
      def new
        @capsule = Capsule.new
      end

      # GET /capsules/1/edit
      def edit
      end

      # POST /capsules
      def create
        @capsule = Capsule.new(capsule_params)
        @capsule.name = @capsule.name.pluralize.downcase

        if @capsule.save
          @capsule.install
          redirect_to edit_admin_capsules_capsule_path(@capsule), notice: actions_messages(@capsule)
        else
          render :new
        end
      end

      # PATCH/PUT /capsules/1
      def update
        if @capsule.update(capsule_params)
          capsule = capsule_params.to_h
          @capsule.new_attributes(@capsule.name, capsule[:capsule_fields_attributes])
          @capsule.new_validations(@capsule.name, capsule[:capsule_validations_attributes])
          redirect_to edit_admin_capsules_capsule_path(@capsule), notice: actions_messages(@capsule)
        else
          render :edit
        end
      end

      def clone
        @capsule = Capsule.clone_record params[:capsule_id]

        if @capsule.save
          redirect_to admin_capsules_capsules_path
        else
          render :new
        end
      end

      # DELETE /capsules/1
      def destroy
        @capsule.destroy if @capsule
        redirect_to admin_capsules_capsules_path, notice: actions_messages(@capsule)
      end

      def destroy_multiple
        Capsule.destroy redefine_ids(params[:multiple_ids])
        redirect_to(
          admin_capsules_capsules_path(page: @current_page, search: @query),
          notice: actions_messages(Capsule.new)
        )
      end

      def destroy_field
        @capsule_field = CapsuleField.where(id: params[:capsule_field_id]).first
        if @capsule_field
          @capsule_field.destroy
          @capsule_field.destroy_migrate
        end
      end

      def destroy_validation
        @capsule_validation = CapsuleValidation.where(id: params[:capsule_validation_id]).first
        if @capsule_validation
          @capsule_validation.destroy
          @capsule_validation.delete_validation_line
        end
      end

      def upload
        Capsule.upload(params[:file])
        redirect_to(
          admin_capsules_path(page: @current_page, search: @query),
          notice: actions_messages(Capsule.new)
        )
      end

      def download
        @capsules = Capsule.all
        respond_to do |format|
          format.html
          format.xls { send_data(@capsules.to_xls) }
          format.json { render json: @capsules }
        end
      end

      def reload
        @q = Capsule.ransack(params[:q])
        capsules = @q.result(distinct: true)
        @objects = capsules.page(@current_page).order(position: :desc)
      end

      def sort
        Capsule.sorter(params[:row])
        @q = Capsule.ransack(params[:q])
        capsules = @q.result(distinct: true)
        @objects = capsules.page(@current_page)
        render :index
      end

      private

      def authorization
        authorize Capsule
      end

      def set_attachments
        @attachments = ['logo', 'brand', 'photo', 'avatar', 'cover', 'image',
                        'picture', 'banner', 'attachment', 'pic', 'file']
      end

      # Use callbacks to share common setup or constraints between actions.
      def set_capsule
        @capsule = Capsule.where(id: params[:id]).first
      end

      # Only allow a trusted parameter "white list" through.
      def capsule_params
        params.require(:capsule).permit(:name, :position, :deleted_at,
                                        capsule_fields_attributes: capsule_fields_attributes,
                                        capsule_validations_attributes: capsule_validations_attributes
                                       )
      end

      def capsule_fields_attributes
        [:id, :name_field, :format_field, :_destroy]
      end

      def capsule_validations_attributes
        [:id, :field, :validation, :name, :_destroy]
      end

      def show_history
        get_history(Capsule)
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
