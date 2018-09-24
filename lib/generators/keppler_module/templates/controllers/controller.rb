require_dependency "<%= ROCKET_NAME %>/application_controller"
<% module_namespacing do -%>
module <%= ROCKET_CLASS_NAME %>
  module Admin
    # <%= MODULE_CLASS_NAME.pluralize.classify %>Controller
    class <%= MODULE_CLASS_NAME.pluralize.classify %>Controller < AdminController
      before_action :set_<%= MODULE_NAME.singularize %>, only: %i[show edit update destroy]
      before_action :show_history, only: %i[index]
      before_action :authorization, except: %i[reload]
      include ObjectQuery

      # GET <%= MODULE_CLASS_NAME %>/<%= MODULE_NAME.pluralize %>
      def index
        @q = <%= MODULE_CLASS_NAME %>.ransack(params[:q])
        @<%= MODULE_NAME.pluralize %> = @q.result(distinct: true)
        @objects = @<%= MODULE_NAME.pluralize %>.page(@current_page).order(position: :desc)
        @total = @<%= MODULE_NAME.pluralize %>.size
        redirect_to_index(@objects)
        respond_to_formats(@<%= MODULE_NAME.pluralize %>)
      end

      # GET <%= ROCKET_NAME %>/<%= MODULE_NAME.pluralize %>/1
      def show; end

      # GET <%= ROCKET_NAME %>/<%= MODULE_NAME.pluralize %>/new
      def new
        @<%= MODULE_NAME.singularize %> = <%= MODULE_CLASS_NAME %>.new
      end

      # GET <%= ROCKET_NAME %>/<%= MODULE_NAME.pluralize %>/1/edit
      def edit; end

      # POST <%= ROCKET_NAME %>/<%= MODULE_NAME.pluralize %>
      def create
        @<%= MODULE_NAME.singularize %> = <%= MODULE_CLASS_NAME %>.new(<%= MODULE_NAME.singularize %>_params)

        if @<%= MODULE_NAME.singularize %>.save
          redirect(@<%= MODULE_NAME.singularize %>, params)
        else
          render :new
        end
      end

      # PATCH/PUT <%= ROCKET_NAME %>/<%= MODULE_NAME.pluralize %>/1
      def update
        if @<%= MODULE_NAME.singularize %>.update(<%= MODULE_NAME.singularize %>_params)
          redirect(@<%= MODULE_NAME.singularize %>, params)
        else
          render :edit
        end
      end

      def clone
        @<%= MODULE_NAME.singularize %> = <%= MODULE_CLASS_NAME %>.clone_record params[:<%=MODULE_NAME.singularize%>_id]

        if @<%= MODULE_NAME.singularize %>.save
          redirect_to_index(@objects)
        else
          render :new
        end
      end

      # DELETE <%= ROCKET_NAME %>/<%= MODULE_NAME.pluralize %>/1
      def destroy
        @<%= MODULE_NAME.singularize %>.destroy
        redirect_to_index(@<%= MODULE_NAME.pluralize %>)
      end

      def destroy_multiple
        <%= MODULE_CLASS_NAME %>.destroy redefine_ids(params[:multiple_ids])
        redirect_to_index(@<%= MODULE_NAME.pluralize %>)
      end

      def upload
        <%= MODULE_CLASS_NAME %>.upload(params[:file])
        redirect_to_index(@<%= MODULE_NAME.pluralize %>)
      end

      def reload
        @q = <%= MODULE_CLASS_NAME %>.ransack(params[:q])
        <%= MODULE_NAME.pluralize %> = @q.result(distinct: true)
        @objects = <%= MODULE_NAME.pluralize %>.page(@current_page).order(position: :desc)
      end

      def sort
        <%= MODULE_CLASS_NAME %>.sorter(params[:row])
        @q = <%= MODULE_CLASS_NAME %>.ransack(params[:q])
        <%= MODULE_NAME.pluralize %> = @q.result(distinct: true)
        @objects = <%= MODULE_NAME.pluralize %>.page(@current_page).order(position: :desc)
      end

      private

      def authorization
        authorize <%= MODULE_CLASS_NAME %>
      end

      # Use callbacks to share common setup or constraints between actions.
      def set_<%= MODULE_NAME.singularize %>
        @<%= MODULE_NAME.singularize %> = <%= MODULE_CLASS_NAME %>.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def <%= MODULE_NAME.singularize %>_params
        <%- if ATTRIBUTES_NAMES.empty? -%>
        params[:<%= MODULE_NAME.singularize %>]
        <%- else -%>
        params.require(:<%= MODULE_NAME.singularize %>).permit(<%= ATTRIBUTES_NAMES.map { |name| ":#{name}" }.join(', ') %>)
        <%- end -%>
      end

      def show_history
        get_history(<%= MODULE_NAME.singularize.camelcase %>)
      end
    end
  end
end
<% end -%>
