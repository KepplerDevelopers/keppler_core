#Generado con Keppler.
<% if namespaced? -%>
require_dependency "<%= namespaced_file_path %>/application_controller"

<% end -%>
<% module_namespacing do -%>
class <%= controller_class_name %>Controller < ApplicationController  
  before_filter :authenticate_user!
  layout 'admin/application'
  load_and_authorize_resource
  before_action :set_<%= singular_table_name %>, only: [:show, :edit, :update, :destroy]
  before_action :show_history, only: [:index]

  # GET <%= route_url %>
  def index
    <%= plural_table_name %> = <%= class_name %>.searching(@query).all
    @objects, @total = <%= plural_table_name %>.page(@current_page), <%= plural_table_name %>.size
    redirect_to <%= plural_table_name %>_path(page: @current_page.to_i.pred, search: @query) if !@objects.first_page? and @objects.size.zero?
  end

  # GET <%= route_url %>/1
  def show
  end

  # GET <%= route_url %>/new
  def new
    @<%= singular_table_name %> = <%= orm_class.build(class_name) %>
  end

  # GET <%= route_url %>/1/edit
  def edit
  end

  # POST <%= route_url %>
  def create
    @<%= orm_instance %> = <%= orm_class.build(class_name, "#{orm_instance}_params") %>

    if @<%= orm_instance.save %>
      redirect(@<%= orm_instance %>, params)
    else
      render :new
    end
  end

  # PATCH/PUT <%= route_url %>/1
  def update
    if @<%= orm_instance.update("#{singular_table_name}_params") %>
      redirect(@<%= orm_instance %>, params)
    else
      render :edit
    end
  end

  # DELETE <%= route_url %>/1
  def destroy
    @<%= orm_instance.destroy %>
    redirect_to <%= index_helper %>_url, notice: t('keppler.messages.successfully.deleted', model: t("keppler.models.singularize.<%= singular_table_name %>").humanize) 
  end

  def destroy_multiple
    <%= class_name %>.destroy redefine_ids(params[:multiple_ids])
    redirect_to <%= plural_table_name %>_path(page: @current_page, search: @query), notice: t('keppler.messages.successfully.removed', model: t("keppler.models.singularize.<%= singular_table_name %>").humanize) 
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_<%= singular_table_name %>
      @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>
    end

    # Only allow a trusted parameter "white list" through.
    def <%= "#{singular_table_name}_params" %>
      <%- if attributes_names.empty? -%>
      params[:<%= singular_table_name %>]
      <%- else -%>
      params.require(:<%= singular_table_name %>).permit(<%= attributes_names.map { |name| ":#{name}" }.join(', ') %>)
      <%- end -%>
    end

    def show_history
      if current_user.has_role? :admin
        @activities = PublicActivity::Activity.where(trackable_type: '<%= singular_table_name.camelcase %>').order("created_at desc").limit(50)
      else
        @activities = PublicActivity::Activity.where("trackable_type = '<%= singular_table_name.camelcase %>' and owner_id=#{current_user.id}").order("created_at desc").limit(50)
      end
    end
end
<% end -%>
