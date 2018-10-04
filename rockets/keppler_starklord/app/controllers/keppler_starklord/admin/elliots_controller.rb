# frozen_string_literal: true

require_dependency "keppler_starklord/application_controller"
module KepplerStarklord
  module Admin
    # ElliotsController
    class ElliotsController < ::Admin::AdminController
      layout 'keppler_starklord/admin/layouts/application'
      before_action :set_elliot, only: %i[show edit update destroy]
      include ObjectQuery

      # GET /elliots
      def index
        @q = Elliot.ransack(params[:q])
        @elliots = @q.result(distinct: true)
        @objects = @elliots.page(@current_page).order(position: :desc)
        @total = @elliots.size
        redirect_to_index(@objects)
        respond_to_formats(@elliots)
      end

      # GET /elliots/1
      def show; end

      # GET /elliots/new
      def new
        @elliot = Elliot.new
      end

      # GET /elliots/1/edit
      def edit; end

      # POST /elliots
      def create
        @elliot = Elliot.new(elliot_params)

        if @elliot.save
          redirect(@elliot, params)
        else
          render :new
        end
      end

      # PATCH/PUT /elliots/1
      def update
        if @elliot.update(elliot_params)
          redirect(@elliot, params)
        else
          render :edit
        end
      end

      def clone
        @elliot = Elliot.clone_record params[:elliot_id]

        if @elliot.save
          redirect_to_index(@objects)
        else
          render :new
        end
      end

      # DELETE /elliots/1
      def destroy
        @elliot.destroy
        redirect_to_index(@elliot)
      end

      def destroy_multiple
        Elliot.destroy redefine_ids(params[:multiple_ids])
        redirect_to_index(@elliot)
      end

      def upload
        Elliot.upload(params[:file])
        redirect_to_index(@elliot)
      end

      def reload
        @q = Elliot.ransack(params[:q])
        elliots = @q.result(distinct: true)
        @objects = elliots.page(@current_page).order(position: :desc)
      end

      def sort
        Elliot.sorter(params[:row])
        @q = Elliot.ransack(params[:q])
        elliots = @q.result(distinct: true)
        @objects = elliots.page(@current_page).order(position: :desc)
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_elliot
        @elliot = Elliot.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def elliot_params
        params.require(:elliot).permit(
          :user_id, :avatar, { photos: [] }, :name, :birthdate, :position, :deleted_at
        )
      end
    end
  end
end
