require_dependency "keppler_capsules/application_controller"
module KepplerCapsules
  module Admin
    # StudentsController
    class StudentsController < ApplicationController
      layout 'keppler_capsules/admin/layouts/application'
      before_action :set_student, only: [:show, :edit, :update, :destroy]
      before_action :show_history, only: [:index]
      before_action :set_attachments
      before_action :authorization
      before_action :set_capsule
      include KepplerCapsules::Concerns::Commons
      include KepplerCapsules::Concerns::History
      include KepplerCapsules::Concerns::DestroyMultiple


      # GET /students
      def index
        @q = Student.ransack(params[:q])
        students = @q.result(distinct: true)
        @objects = students.page(@current_page).order(position: :asc)
        @total = students.size
        @students = @objects.all
        if !@objects.first_page? && @objects.size.zero?
          redirect_to students_path(page: @current_page.to_i.pred, search: @query)
        end
        respond_to do |format|
          format.html
          format.xls { send_data(@students.to_xls) }
          format.json { render :json => @objects }
        end
      end

      # GET /students/1
      def show
      end

      # GET /students/new
      def new
        @student = Student.new
      end

      # GET /students/1/edit
      def edit
      end

      # POST /students
      def create
        @student = Student.new(student_params)

        if @student.save
          redirect(@student, params)
        else
          render :new
        end
      end

      # PATCH/PUT /students/1
      def update
        if @student.update(student_params)
          redirect(@student, params)
        else
          render :edit
        end
      end

      def clone
        @student = Student.clone_record params[:student_id]

        if @student.save
          redirect_to admin_capsules_students_path
        else
          render :new
        end
      end

      # DELETE /students/1
      def destroy
        @student.destroy if @student
        redirect_to admin_capsules_students_path, notice: ''
      end

      def destroy_multiple
        Student.destroy redefine_ids(params[:multiple_ids])
        redirect_to(
          admin_capsules_students_path(page: @current_page, search: @query),
          notice: ''
        )
      end

      def upload
        Student.upload(params[:file])
        redirect_to(
          admin_students_path(page: @current_page, search: @query),
          notice: ''
        )
      end

      def download
        @students = Student.all
        respond_to do |format|
          format.html
          format.xls { send_data(@students.to_xls) }
          format.json { render json: @students }
        end
      end

      def reload
        @q = Student.ransack(params[:q])
        students = @q.result(distinct: true)
        @objects = students.page(@current_page).order(position: :desc)
      end

      def sort
        Student.sorter(params[:row])
        @q = Student.ransack(params[:q])
        students = @q.result(distinct: true)
        @objects = students.page(@current_page)
        render :index
      end

      private

      def authorization
        authorize Student
      end

      def set_attachments
        @attachments = ['logo', 'brand', 'photo', 'avatar', 'cover', 'image',
                        'picture', 'banner', 'attachment', 'pic', 'file']
      end

      def set_capsule
        @capsule = Capsule.find_by_name('students')
      end

      # Use callbacks to share common setup or constraints between actions.
      def set_student
        @student = Student.where(id: params[:id]).first
      end

      # Only allow a trusted parameter "white list" through.
      def student_params
        attributes = @capsule.capsule_fields.map(&:name_field.to_sym)
        params.require(:student).permit(attributes)
      end

      def show_history
        get_history(Student)
      end

      def get_history(model)
        @activities = PublicActivity::Activity.where(
          trackable_type: model.to_s
        ).order('created_at desc').limit(50)
      end

      # Get submit key to redirect, only [:create, :update]
      def redirect(object, commit)
        if commit.key?('_save')
          redirect_to([:admin, :capsules, object], notice: '')
        elsif commit.key?('_add_other')
          redirect_to(
            send("new_admin_capsules_#{underscore(object)}_path"),
            notice: ''
          )
        end
      end
    end
  end
end
