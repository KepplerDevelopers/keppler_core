# frozen_string_literal: true

require_dependency "<%= ROCKET_NAME %>/application_controller"
module <%= ROCKET_CLASS_NAME %>
  module Admin
    # <%= MODULE_CLASS_NAME.pluralize %>Controller
    class <%= MODULE_CLASS_NAME.pluralize %>Controller < ::Admin::AdminController
      layout '<%= ROCKET_NAME %>/admin/layouts/application'
      before_action :set_<%= MODULE_NAME.singularize %>, only: %i[show edit update destroy]
      before_action :index_variables
      include ObjectQuery

      # GET <%= route_url %>
      def index
        respond_to_formats(@<%= MODULE_NAME.pluralize %>)
        redirect_to_index(@objects)
      end

      # GET <%= route_url %>/1
      def show; end

      # GET <%= route_url %>/new
      def new
        @<%= MODULE_NAME.singularize %> = <%= MODULE_CLASS_NAME %>.new
      end

      # GET <%= route_url %>/1/edit
      def edit; end

      # POST <%= route_url %>
      def create
        @<%= MODULE_NAME.singularize %> = <%= MODULE_CLASS_NAME %>.new(<%= MODULE_NAME.singularize %>_params)

        if @<%= MODULE_NAME.singularize %>.save
          redirect(@<%= MODULE_NAME.singularize %>, params)
        else
          render :new
        end
      end

      # PATCH/PUT <%= route_url %>/1
      def update
        if <%= MODULE_CLASS_NAME %>.update(<%= MODULE_NAME.singularize %>_params)
          redirect(@<%= MODULE_NAME.singularize %>, params)
        else
          render :edit
        end
      end

      def clone
        @<%= MODULE_NAME.singularize %> = <%= MODULE_CLASS_NAME %>.clone_record params[:<%=MODULE_NAME.singularize%>_id]
        @<%= MODULE_NAME.singularize %>.save
        redirect_to_index(@objects)
      end

      # DELETE <%= route_url %>/1
      def destroy
        @<%= MODULE_NAME.singularize %>.destroy
        redirect_to_index(@objects)
      end

      def destroy_multiple
        <%= MODULE_CLASS_NAME %>.destroy redefine_ids(params[:multiple_ids])
        redirect_to_index(@objects)
      end

      def upload
        <%= MODULE_CLASS_NAME %>.upload(params[:file])
        redirect_to_index(@objects)
      end

      def reload; end

      def sort
        <%= MODULE_CLASS_NAME %>.sorter(params[:row])
      end

      private

      def index_variables
        @q = <%= MODULE_CLASS_NAME %>.ransack(params[:q])
        @<%= MODULE_NAME.pluralize %> = @q.result(distinct: true)
        @objects = @<%= MODULE_NAME.pluralize %>.page(@current_page).order(position: :desc)
        @total = @<%= MODULE_NAME.pluralize %>.size
        @attributes = <%= MODULE_CLASS_NAME %>.index_attributes
      end

      # Use callbacks to share common setup or constraints between actions.
      def set_<%= MODULE_NAME.singularize %>
        @<%= MODULE_NAME.singularize %> = <%= MODULE_CLASS_NAME %>.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def <%= "#{MODULE_NAME.singularize}_params" %>
        <%- if ATTRIBUTES_NAMES.empty? -%>
        params[:<%= MODULE_NAME.singularize %>]
        <%- else -%>
        params.require(:<%= MODULE_NAME.singularize %>).permit(
          <%= ATTRIBUTES.map { |attribute| attribute.last.eql?(:jsonb) ? "{ #{attribute.first}: [] }" : (attribute.last.eql?("references") ? ":#{attribute.first}_id" : ":#{attribute.first}") }.join(', ') %>
        )
        <%- end -%>
      end
    end
  end
end