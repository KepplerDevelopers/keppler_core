module Admin
  # CategoriesController
  class CategoriesController < AdminController
    before_action :set_category, only: [:show, :edit, :update, :destroy]
    before_action :show_history, only: [:index]

    # GET /categories
    def index
      @q = Category.ransack(params[:q])
      categories = @q.result(distinct: true)
      @objects = categories.page(@current_page)
      @total = categories.size
      if !@objects.first_page? && @objects.size.zero?
        redirect_to categories_path(page: @current_page.to_i.pred, search: @query)
      end
      @categories = Category.all
      respond_to do |format|
        format.html
        format.xls { send_data(@categories.to_xls) }
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

    def clone
      @category = Category.clone_record params[:category_id]

      if @category.save
        redirect_to admin_categories_path
      else
        render :new
      end
    end

    # DELETE /categories/1
    def destroy
      @category.destroy
      redirect_to admin_categories_path, notice: actions_messages(@category)
    end

    def destroy_multiple
      Category.destroy redefine_ids(params[:multiple_ids])
      redirect_to(
        admin_categories_path(page: @current_page, search: @query),
        notice: actions_messages(Category.new)
      )
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def category_params
      params.require(:category).permit(:icon, :name)
    end

    def show_history
      get_history(Category)
    end
  end
end
