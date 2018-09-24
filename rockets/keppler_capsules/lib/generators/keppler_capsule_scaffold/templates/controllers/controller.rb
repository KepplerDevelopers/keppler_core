<% if namespaced? -%>
require_dependency "<%= namespaced_path %>/application_controller"
<% end -%>
<% module_namespacing do -%>
module Admin
  # <%= controller_class_name %>Controller
  class <%= controller_class_name %>Controller < ApplicationController
    layout '<%= namespaced_path %>/admin/layouts/application'
    before_action :set_<%= singular_table_name %>, only: [:show, :edit, :update, :destroy]
    before_action :show_history, only: [:index]
    before_action :set_attachments
    before_action :authorization
    before_action :set_capsule
    include <%= namespaced_path.split('_').map(&:capitalize).join('') %>::Concerns::Commons
    include <%= namespaced_path.split('_').map(&:capitalize).join('') %>::Concerns::History
    include <%= namespaced_path.split('_').map(&:capitalize).join('') %>::Concerns::DestroyMultiple


    # GET <%= route_url %>
    def index
      @q = <%= class_name %>.ransack(params[:q])
      <%= plural_table_name %> = @q.result(distinct: true)
      @objects = <%= plural_table_name %>.page(@current_page).order(position: :asc)
      @total = <%= plural_table_name %>.size
      @<%= plural_table_name %> = @objects.all
      if !@objects.first_page? && @objects.size.zero?
        redirect_to <%= plural_table_name %>_path(page: @current_page.to_i.pred, search: @query)
      end
      respond_to do |format|
        format.html
        format.xls { send_data(@<%= plural_table_name %>.to_xls) }
        format.json { render :json => @objects }
      end
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
        redirect_to admin_<%= namespaced_path.split('_').drop(1).join('_') %>_<%= index_helper %>_path
      else
        render :new
      end
    end

    # DELETE <%= route_url %>/1
    def destroy
      @<%= orm_instance.destroy %> if @<%= singular_table_name %>
      redirect_to admin_<%= namespaced_path.split('_').drop(1).join('_') %>_<%= index_helper %>_path, notice: ''
    end

    def destroy_multiple
      <%= class_name %>.destroy redefine_ids(params[:multiple_ids])
      redirect_to(
        admin_<%= namespaced_path.split('_').drop(1).join('_') %>_<%= index_helper %>_path(page: @current_page, search: @query),
        notice: ''
      )
    end

    def upload
      <%= class_name %>.upload(params[:file])
      redirect_to(
        admin_<%= index_helper %>_path(page: @current_page, search: @query),
        notice: ''
      )
    end

    def download
      @<%= plural_table_name %> = <%= class_name %>.all
      respond_to do |format|
        format.html
        format.xls { send_data(@<%= plural_table_name %>.to_xls) }
        format.json { render json: @<%= plural_table_name %> }
      end
    end

    def reload
      @q = <%= class_name %>.ransack(params[:q])
      <%= plural_table_name %> = @q.result(distinct: true)
      @objects = <%= plural_table_name %>.page(@current_page).order(position: :desc)
    end

    def sort
      <%= class_name %>.sorter(params[:row])
      @q = <%= class_name %>.ransack(params[:q])
      <%= plural_table_name %> = @q.result(distinct: true)
      @objects = <%= plural_table_name %>.page(@current_page)
      render :index
    end

    private

    def authorization
      authorize <%= class_name %>
    end

    def set_attachments
      SINGULAR_ATTACHMENTS = ['logo', 'brand', 'photo', 'avatar', 'cover', 'image',
                      'picture', 'banner', 'attachment', 'pic', 'file']
    end

    def set_capsule
      @capsule = Capsule.find_by_name('<%= controller_class_name.downcase %>')
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_<%= singular_table_name %>
      @<%= singular_table_name %> = <%= singular_table_name.capitalize %>.where(id: params[:id]).first
    end

    # Only allow a trusted parameter "white list" through.
    def <%= "#{singular_table_name}_params" %>
      attributes = @capsule.capsule_fields.map(&:name_field.to_sym)
      <%- if attributes_names.empty? -%>
      params[:<%= singular_table_name %>]
      <%- else -%>
      params.require(:<%= singular_table_name %>).permit(attributes)
      <%- end -%>
    end

    def show_history
      get_history(<%= singular_table_name.camelcase %>)
    end

    def get_history(model)
      @activities = PublicActivity::Activity.where(
        trackable_type: model.to_s
      ).order('created_at desc').limit(50)
    end

    # Get submit key to redirect, only [:create, :update]
    def redirect(object, commit)
      if commit.key?('_save')
        redirect_to([:admin, :<%= namespaced_path.split('_').drop(1).join('_') %>, object], notice: '')
      elsif commit.key?('_add_other')
        redirect_to(
          send("new_admin_<%= namespaced_path.split('_').drop(1).join('_') %>_#{underscore(object).split('/').last}_path"),
          notice: ''
        )
      end
    end
  end
end
<% end -%>
