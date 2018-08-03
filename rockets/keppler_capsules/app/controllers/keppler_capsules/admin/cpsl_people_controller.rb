require_dependency "keppler_capsules/application_controller"
module KepplerCapsules
  module Admin
    # CpslPeopleController
    class CpslPeopleController < ApplicationController
      layout 'keppler_capsules/admin/layouts/application'
      before_action :set_cpsl_person, only: [:show, :edit, :update, :destroy]
      before_action :show_history, only: [:index]
      before_action :set_attachments
      before_action :authorization
      include KepplerCapsules::Concerns::Commons
      include KepplerCapsules::Concerns::History
      include KepplerCapsules::Concerns::DestroyMultiple


      # GET /cpsl_people
      def index
        @q = CpslPerson.ransack(params[:q])
        cpsl_people = @q.result(distinct: true)
        @objects = cpsl_people.page(@current_page).order(position: :asc)
        @total = cpsl_people.size
        @cpsl_people = @objects.all
        if !@objects.first_page? && @objects.size.zero?
          redirect_to cpsl_people_path(page: @current_page.to_i.pred, search: @query)
        end
        respond_to do |format|
          format.html
          format.xls { send_data(@cpsl_people.to_xls) }
          format.json { render :json => @objects }
        end
      end

      # GET /cpsl_people/1
      def show
      end

      # GET /cpsl_people/new
      def new
        @cpsl_person = CpslPerson.new
      end

      # GET /cpsl_people/1/edit
      def edit
      end

      # POST /cpsl_people
      def create
        @cpsl_person = CpslPerson.new(cpsl_person_params)

        if @cpsl_person.save
          redirect(@cpsl_person, params)
        else
          render :new
        end
      end

      # PATCH/PUT /cpsl_people/1
      def update
        if @cpsl_person.update(cpsl_person_params)
          redirect(@cpsl_person, params)
        else
          render :edit
        end
      end

      def clone
        @cpsl_person = CpslPerson.clone_record params[:cpsl_person_id]

        if @cpsl_person.save
          redirect_to admin_capsules_cpsl_people_path
        else
          render :new
        end
      end

      # DELETE /cpsl_people/1
      def destroy
        @cpsl_person.destroy
        redirect_to admin_capsules_cpsl_people_path, notice: actions_messages(@cpsl_person)
      end

      def destroy_multiple
        CpslPerson.destroy redefine_ids(params[:multiple_ids])
        redirect_to(
          admin_cpsl_people_path(page: @current_page, search: @query),
          notice: actions_messages(CpslPerson.new)
        )
      end

      def upload
        CpslPerson.upload(params[:file])
        redirect_to(
          admin_cpsl_people_path(page: @current_page, search: @query),
          notice: actions_messages(CpslPerson.new)
        )
      end

      def download
        @cpsl_people = CpslPerson.all
        respond_to do |format|
          format.html
          format.xls { send_data(@cpsl_people.to_xls) }
          format.json { render json: @cpsl_people }
        end
      end

      def reload
        @q = CpslPerson.ransack(params[:q])
        cpsl_people = @q.result(distinct: true)
        @objects = cpsl_people.page(@current_page).order(position: :desc)
      end

      def sort
        CpslPerson.sorter(params[:row])
        @q = CpslPerson.ransack(params[:q])
        cpsl_people = @q.result(distinct: true)
        @objects = cpsl_people.page(@current_page)
        render :index
      end

      private

      def authorization
        authorize CpslPerson
      end

      def set_attachments
        @attachments = ['logo', 'brand', 'photo', 'avatar', 'cover', 'image',
                        'picture', 'banner', 'attachment', 'pic', 'file']
      end

      # Use callbacks to share common setup or constraints between actions.
      def set_cpsl_person
        @cpsl_person = CpslPerson.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def cpsl_person_params
        params.require(:cpsl_person).permit(:name, :phone, :position, :deleted_at)
      end

      def show_history
        get_history(CpslPerson)
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
