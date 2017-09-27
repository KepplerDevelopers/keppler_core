module Admin
  # BannersController
  class BannersController < AdminController
    before_action :set_banner, only: [:show, :edit, :update, :destroy]
    before_action :show_history, only: [:index]

    # GET /banners
    def index
      @q = Banner.ransack(params[:q])
      banners = @q.result(distinct: true)
      @objects = banners.page(@current_page)
      @total = banners.size
      if !@objects.first_page? && @objects.size.zero?
        redirect_to banners_path(page: @current_page.to_i.pred, search: @query)
      end
      @banners = Banner.all
      respond_to do |format|
        format.html
        format.xls { send_data(@banners.to_xls) }
      end
    end

    # GET /banners/1
    def show
    end

    # GET /banners/new
    def new
      @banner = Banner.new
    end

    # GET /banners/1/edit
    def edit
    end

    # POST /banners
    def create
      @banner = Banner.new(banner_params)

      if @banner.save
        redirect(@banner, params)
      else
        render :new
      end
    end

    # PATCH/PUT /banners/1
    def update
      if @banner.update(banner_params)
        redirect(@banner, params)
      else
        render :edit
      end
    end

    def clone
      @banner = Banner.clone_record params[:banner_id]

      if @banner.save
        redirect_to admin_banners_path
      else
        render :new
      end
    end

    # DELETE /banners/1
    def destroy
      @banner.destroy
      redirect_to admin_banners_path, notice: actions_messages(@banner)
    end

    def destroy_multiple
      Banner.destroy redefine_ids(params[:multiple_ids])
      redirect_to(
        admin_banners_path(page: @current_page, search: @query),
        notice: actions_messages(Banner.new)
      )
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_banner
      @banner = Banner.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def banner_params
      params.require(:banner).permit(:cover, :category_id)
    end

    def show_history
      get_history(Banner)
    end
  end
end
