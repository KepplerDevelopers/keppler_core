# frozen_string_literal: true

require_dependency "keppler_world/application_controller"
module KepplerWorld
  module Admin
    # PlanetsController
    class PlanetsController < ::Admin::AdminController
      layout 'keppler_world/admin/layouts/application'
      before_action :set_planet, only: %i[show edit update destroy]
      before_action :index_variables
      include ObjectQuery

      # GET /planets
      def index
        respond_to_formats(@planets)
        redirect_to_index(@objects)
      end

      # GET /planets/1
      def show; end

      # GET /planets/new
      def new
        @planet = Planet.new
      end

      # GET /planets/1/edit
      def edit; end

      # POST /planets
      def create
        @planet = Planet.new(planet_params)

        if @planet.save
          redirect(@planet, params)
        else
          render :new
        end
      end

      # PATCH/PUT /planets/1
      def update
        if @planet.update(planet_params)
          redirect(@planet, params)
        else
          render :edit
        end
      end

      def clone
        @planet = Planet.clone_record params[:planet_id]
        @planet.save
        redirect_to_index(@objects)
      end

      # DELETE /planets/1
      def destroy
        @planet.destroy
        redirect_to_index(@objects)
      end

      def destroy_multiple
        Planet.destroy redefine_ids(params[:multiple_ids])
        redirect_to_index(@objects)
      end

      def upload
        Planet.upload(params[:file])
        redirect_to_index(@objects)
      end

      def reload; end

      def sort
        Planet.sorter(params[:row])
      end

      private

      def index_variables
        @q = Planet.ransack(params[:q])
        @planets = @q.result(distinct: true)
        @objects = @planets.page(@current_page).order(position: :desc)
        @total = @planets.size
        @attributes = Planet.index_attributes
      end

      # Use callbacks to share common setup or constraints between actions.
      def set_planet
        @planet = Planet.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def planet_params
        params.require(:planet).permit(
          { images: [] }, :avatar, :name, :description, :age, :money, :fecha, :tiempo, :position, :deleted_at
        )
      end
    end
  end
end
