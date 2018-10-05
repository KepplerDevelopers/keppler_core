# frozen_string_literal: true

<% if namespaced? -%>
require_dependency "<%= namespaced_path %>/application_controller"
<% end -%>
<% module_namespacing do -%>
module Admin
  # <%= controller_class_name %>Controller
  class <%= controller_class_name %>Controller < ::Admin::AdminController
    layout '<%= namespaced_path %>/admin/layouts/application'
    before_action :set_<%= singular_table_name %>, only: %i[show edit update destroy]
    before_action :index_variables
    include ObjectQuery

    # GET <%= route_url %>
    def index
      respond_to_formats(@<%= plural_table_name %>)
      redirect_to_index(@objects)
    end

    # GET <%= route_url %>/1
    def show; end

    # GET <%= route_url %>/new
    def new
      @<%= singular_table_name %> = <%= orm_class.build(class_name) %>
    end

    # GET <%= route_url %>/1/edit
    def edit; end

    # POST <%= route_url %>
    def create
      @<%= singular_table_name %> = <%= orm_class.build(class_name, "#{singular_table_name}_params") %>

      if @<%= orm_instance.save %>
        redirect(@<%= singular_table_name %>, params)
      else
        render :new
      end
    end

    # PATCH/PUT <%= route_url %>/1
    def update
      if @<%= orm_instance.update("#{singular_table_name}_params") %>
        redirect(@<%= singular_table_name %>, params)
      else
        render :edit
      end
    end

    def clone
      @<%= singular_table_name %> = <%= class_name %>.clone_record params[:<%=singular_table_name%>_id]
      @<%= singular_table_name %>.save
      redirect_to_index(@objects)
    end

    # DELETE <%= route_url %>/1
    def destroy
      @<%= orm_instance.destroy %>
      redirect_to_index(@objects)
    end

    def destroy_multiple
      <%= class_name %>.destroy redefine_ids(params[:multiple_ids])
      redirect_to_index(@objects)
    end

    def upload
      <%= class_name %>.upload(params[:file])
      redirect_to_index(@objects)
    end

    def reload; end

    def sort
      <%= class_name %>.sorter(params[:row])
    end

    private

    def index_variables
      @q = <%= class_name %>.ransack(params[:q])
      @<%= plural_table_name %> = @q.result(distinct: true)
      @objects = @<%= plural_table_name %>.page(@current_page).order(position: :desc)
      @total = @<%= plural_table_name %>.size
      @attributes = <%= class_name %>.index_attributes
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_<%= singular_table_name %>
      @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>
    end

    # Only allow a trusted parameter "white list" through.
    def <%= "#{singular_table_name}_params" %>
      <%- if attributes_names.empty? -%>
      params[:<%= singular_table_name %>]
      <%- else -%>
      params.require(:<%= singular_table_name %>).permit(
        <%= attributes.map { |attribute| attribute.type.eql?(:jsonb) ? "{ #{attribute.name}: [] }" : (attribute.reference? ? ":#{attribute.name}_id" : ":#{attribute.name}") }.join(', ') %>
      )
      <%- end -%>
    end
  end
end
<% end -%>
