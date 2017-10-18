module Admin
  # ShopsController
  class ShopsController < AdminController
    before_action :set_shop, only: [:show, :edit, :update, :destroy]
    before_action :show_history, only: [:index]
    before_action :set_category


    # GET /shops
    def index
      @q = Shop.ransack(@category_shop)
      shops = @q.result(distinct: true).where(category_id: @category_shop)
      @objects = shops.page(@current_page)
      @total = shops.size
      if !@objects.first_page? && @objects.size.zero?
        redirect_to shops_path(page: @current_page.to_i.pred, search: @query)
      end
      @shops = Shop.all
      respond_to do |format|
        format.html
        format.xls { send_data(@shops.to_xls) }
      end
    end

    # GET /shops/1
    def show
    end

    # GET /shops/new
    def new
      @shop = Shop.new(category_id: params[:category_id])
    end

    # GET /shops/1/edit
    def edit
    end

    # POST /shops
    def create
      @shop = Shop.new(shop_params)

      if @shop.save
        if params.key?('_add_other')
          redirect_to new_admin_category_shop_path, notice: actions_messages(@shop)
        else
          redirect_to admin_category_shops_path
        end
      else
        render :new
      end
    end

    # PATCH/PUT /shops/1
    def update
      if @shop.update(shop_params)
        if params.key?('_add_other')
          redirect_to new_admin_category_shop_path, notice: actions_messages(@shop)
        else
          redirect_to admin_category_shops_path
        end
      else
        render :edit
      end
    end

    def clone
      @shop = Shop.clone_record params[:shop_id]

      if @shop.save
        redirect_to admin_category_shops_path
      else
        render :new
      end
    end

    # DELETE /shops/1
    def destroy
      @shop.destroy
      redirect_to admin_category_shops_path, notice: actions_messages(@shop)
    end

    def destroy_multiple
      Shop.destroy redefine_ids(params[:multiple_ids])
      redirect_to(
        admin_category_shops_path(page: @current_page, search: @query),
        notice: actions_messages(Shop.new)
      )
    end

    private

    def set_category
      @category_shop = Category.find(params[:category_id])
    end


    # Use callbacks to share common setup or constraints between actions.
    def set_shop
      @shop = Shop.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def shop_params
      params.require(:shop).permit(:image, :name, :category_id)
    end

    def show_history
      get_history(Shop)
    end
  end
end
