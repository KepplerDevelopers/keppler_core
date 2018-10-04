# frozen_string_literal: true

require_dependency "keppler_capsules/application_controller"
module KepplerCapsules
  module Admin
    # PeopleController
    class PeopleController < ::Admin::AdminController
      layout 'keppler_capsules/admin/layouts/application'
      before_action :set_person, only: %i[show edit update destroy]
      include ObjectQuery

      # GET /people
      def index
        @q = Person.ransack(params[:q])
        @people = @q.result(distinct: true)
        @objects = @people.page(@current_page).order(position: :desc)
        @total = @people.size
        redirect_to_index(@objects)
        respond_to_formats(@people)
      end

      # GET /people/1
      def show; end

      # GET /people/new
      def new
        @person = Person.new
      end

      # GET /people/1/edit
      def edit; end

      # POST /people
      def create
        @person = Person.new(person_params)

        if @person.save
          redirect(@person, params)
        else
          render :new
        end
      end

      # PATCH/PUT /people/1
      def update
        if @person.update(person_params)
          redirect(@person, params)
        else
          render :edit
        end
      end

      def clone
        @person = Person.clone_record params[:person_id]

        if @person.save
          redirect_to_index(@objects)
        else
          render :new
        end
      end

      # DELETE /people/1
      def destroy
        @person.destroy
        redirect_to_index(@person)
      end

      def destroy_multiple
        Person.destroy redefine_ids(params[:multiple_ids])
        redirect_to_index(@person)
      end

      def upload
        Person.upload(params[:file])
        redirect_to_index(@person)
      end

      def reload
        @q = Person.ransack(params[:q])
        people = @q.result(distinct: true)
        @objects = people.page(@current_page).order(position: :desc)
      end

      def sort
        Person.sorter(params[:row])
        @q = Person.ransack(params[:q])
        people = @q.result(distinct: true)
        @objects = people.page(@current_page).order(position: :desc)
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_person
        @person = Person.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def person_params
        params.require(:person).permit(
          :asdasd, :asdads, :sdasd, :position, :deleted_at
        )
      end
    end
  end
end
