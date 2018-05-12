<% if namespaced? -%>
require_dependency "<%= namespaced_file_path %>/application_controller"
<% end -%>
<% module_namespacing do -%>
module Admin
  # <%= controller_class_name %>Controller
  class <%= controller_class_name %>Controller < AdminController
    before_action :set_<%= singular_table_name %>, only: [:show, :edit, :update, :destroy]
    before_action :show_history, only: [:index]
    before_action :set_attachments
    before_action :authorization

    # GET <%= route_url %>
    def index
      @q = <%= class_name %>.ransack(params[:q])
      <%= plural_table_name %> = @q.result(distinct: true)
      @objects = <%= plural_table_name %>.page(@current_page).order(position: :desc)
      @total = <%= plural_table_name %>.size
      @<%= plural_table_name %> = @objects.order(:position)
      if !@objects.first_page? && @objects.size.zero?
        redirect_to <%= plural_table_name %>_path(page: @current_page.to_i.pred, search: @query)
      end
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

      if @<%= singular_table_name %>.save
        redirect_to admin_<%= index_helper %>_path
      else
        render :new
      end
    end

    # DELETE <%= route_url %>/1
    def destroy
      @<%= orm_instance.destroy %>
      redirect_to admin_<%= index_helper %>_path, notice: actions_messages(@<%= singular_table_name %>)
    end

    def destroy_multiple
      <%= class_name %>.destroy redefine_ids(params[:multiple_ids])
      redirect_to(
        admin_<%= index_helper %>_path(page: @current_page, search: @query),
        notice: actions_messages(<%= orm_class.build(class_name) %>)
      )
    end

    def upload
      <%= class_name %>.upload(params[:file])
      redirect_to(
        admin_<%= index_helper %>_path(page: @current_page, search: @query),
        notice: actions_messages(<%= orm_class.build(class_name) %>)
      )
    end

    def download
      @<%= plural_table_name %> = <%= class_name %>.all
      respond_to do |format|
        format.html
        format.xls { send_data(@<%= plural_table_name %>.to_xls) }
        format.json { render :json => @<%= plural_table_name %> }
      end
    end

    def reload
      @q = <%= class_name %>.ransack(params[:q])
      <%= plural_table_name %> = @q.result(distinct: true)
      @objects = <%= plural_table_name %>.page(@current_page).order(position: :desc)
    end

    def sort
      <%= class_name %>.sorter(params[:row])
      render :index
    end

    private

    def authorization
      authorize <%= class_name %>
    end

    def set_attachments
      @attachments = ['logo', 'brand', 'photo', 'avatar', 'cover', 'image',
                      'picture', 'banner', 'attachment', 'pic', 'file']
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
      params.require(:<%= singular_table_name %>).permit(<%= attributes_names.map { |name| ":#{name}" }.join(', ') %>)
      <%- end -%>
    end

    def show_history
      get_history(<%= singular_table_name.camelcase %>)
    end
  end
end
<% end -%>
