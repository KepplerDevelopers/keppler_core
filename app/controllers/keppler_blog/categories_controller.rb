#Generado con Keppler.
require_dependency "keppler_blog/application_controller"

module KepplerBlog
  class CategoriesController < Admin::AdminController
    before_filter :authenticate_user!
    layout 'admin/layouts/application'
    load_and_authorize_resource
    before_action :set_category, only: [:show, :edit, :update, :destroy]
    before_action :show_history, only: [:index]

    # GET /categories
    def index
      @q = Category.ransack(params[:q])
      categories = @q.result(distinct: true)
      @objects = categories.page(@current_page)
      @total = categories.size

      if !@objects.first_page? && @objects.size.zero?
        redirect_to(
          posts_path(page: @current_page.to_i.pred, search: @query)
        )
      end
    end

    # GET /categories/1
    def show
    end

    # GET /categories/new
    def new
      @category = Category.new
    end

    # GET /categories/1/edit
    def edit
    end

    # POST /categories
    def create
      @category = Category.new(category_params)

      if @category.save
        redirect(@category, params)
      else
        render :new
      end
    end

    # PATCH/PUT /categories/1
    def update
      if @category.update(category_params)
        redirect(@category, params)
      else
        render :edit
      end
    end

    # DELETE /categories/1
    def destroy
      @category.destroy
      redirect_to categories_url, notice: actions_messages(@category)
    end

    def destroy_multiple
      Category.destroy redefine_ids(params[:multiple_ids])
      redirect_to categories_path(
        page: @current_page, search: @query
      ), notice: actions_messages(Category.new)
    end

    private

    # Get submit key to redirect, only [:create, :update]
    def redirect(object, commit)
      if commit.key?('_save')
        redirect_to(object, notice: actions_messages(object))
      elsif commit.key?('_add_other')
        redirect_to(
          new_category_path,
          notice: actions_messages(object)
        )
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def category_params
      params.require(:category).permit(:name, subcategories_attributes: [:id, :name, :_destroy])
    end

    def show_history
      get_history(Category)
    end
  end
end
