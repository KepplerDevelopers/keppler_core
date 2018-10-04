# frozen_string_literal: true

require_dependency "keppler_capsules/application_controller"
module KepplerCapsules
  module Admin
    # DogsController
    class DogsController < ::Admin::AdminController
      layout 'keppler_capsules/admin/layouts/application'
      before_action :set_dog, only: %i[show edit update destroy]
      include ObjectQuery

      # GET /dogs
      def index
        @q = Dog.ransack(params[:q])
        @dogs = @q.result(distinct: true)
        @objects = @dogs.page(@current_page).order(position: :desc)
        @total = @dogs.size
        redirect_to_index(@objects)
        respond_to_formats(@dogs)
      end

      # GET /dogs/1
      def show; end

      # GET /dogs/new
      def new
        @dog = Dog.new
      end

      # GET /dogs/1/edit
      def edit; end

      # POST /dogs
      def create
        @dog = Dog.new(dog_params)

        if @dog.save
          redirect(@dog, params)
        else
          render :new
        end
      end

      # PATCH/PUT /dogs/1
      def update
        if @dog.update(dog_params)
          redirect(@dog, params)
        else
          render :edit
        end
      end

      def clone
        @dog = Dog.clone_record params[:dog_id]

        if @dog.save
          redirect_to_index(@objects)
        else
          render :new
        end
      end

      # DELETE /dogs/1
      def destroy
        @dog.destroy
        redirect_to_index(@dog)
      end

      def destroy_multiple
        Dog.destroy redefine_ids(params[:multiple_ids])
        redirect_to_index(@dog)
      end

      def upload
        Dog.upload(params[:file])
        redirect_to_index(@dog)
      end

      def reload
        @q = Dog.ransack(params[:q])
        dogs = @q.result(distinct: true)
        @objects = dogs.page(@current_page).order(position: :desc)
      end

      def sort
        Dog.sorter(params[:row])
        @q = Dog.ransack(params[:q])
        dogs = @q.result(distinct: true)
        @objects = dogs.page(@current_page).order(position: :desc)
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_dog
        @dog = Dog.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def dog_params
        params.require(:dog).permit(
          :name, :position, :deleted_at
        )
      end
    end
  end
end
