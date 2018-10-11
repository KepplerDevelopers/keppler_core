# frozen_string_literal: true

require_dependency "keppler_to_do/application_controller"
module KepplerToDo
  module Admin
    # TasksController
    class TasksController < ::Admin::AdminController
      layout 'keppler_to_do/admin/layouts/application'
      before_action :set_task, only: %i[show edit update destroy]
      before_action :index_variables
      include ObjectQuery

      # GET /tasks
      def index
        respond_to_formats(@tasks)
        redirect_to_index(@objects)
      end

      # GET /tasks/1
      def show; end

      # GET /tasks/new
      def new
        @task = Task.new
      end

      # GET /tasks/1/edit
      def edit; end

      # POST /tasks
      def create
        @task = Task.new(task_params)

        if @task.save
          redirect(@task, params)
        else
          render :new
        end
      end

      # PATCH/PUT /tasks/1
      def update
        if @task.update(task_params)
          redirect(@task, params)
        else
          render :edit
        end
      end

      def clone
        @task = Task.clone_record params[:task_id]
        @task.save
        redirect_to_index(@objects)
      end

      # DELETE /tasks/1
      def destroy
        @task.destroy
        redirect_to_index(@objects)
      end

      def destroy_multiple
        Task.destroy redefine_ids(params[:multiple_ids])
        redirect_to_index(@objects)
      end

      def upload
        Task.upload(params[:file])
        redirect_to_index(@objects)
      end

      def reload; end

      def sort
        Task.sorter(params[:row])
      end

      private

      def index_variables
        @q = Task.ransack(params[:q])
        @tasks = @q.result(distinct: true)
        @objects = @tasks.page(@current_page).order(position: :desc)
        @total = @tasks.size
        @attributes = Task.index_attributes
      end

      # Use callbacks to share common setup or constraints between actions.
      def set_task
        @task = Task.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def task_params
        params.require(:task).permit(
          :name, :position, :deleted_at
        )
      end
    end
  end
end
