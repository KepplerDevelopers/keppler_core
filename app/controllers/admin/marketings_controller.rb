module Admin
  # MarketingsController
  class MarketingsController < AdminController
    before_action :set_marketing, only: [:show, :edit, :update, :destroy]
    before_action :show_history, only: [:index]

    # GET /marketings
    def index
      @q = Marketing.ransack(params[:q])
      marketings = @q.result(distinct: true)
      @objects = marketings.page(@current_page)
      @total = marketings.size
      if !@objects.first_page? && @objects.size.zero?
        redirect_to marketings_path(page: @current_page.to_i.pred, search: @query)
      end
      @marketings = Marketing.all.reverse
      respond_to do |format|
        format.html
        format.xls { send_data(@marketings.to_xls) }
      end
    end

    # GET /marketings/1
    def show
    end

    # GET /marketings/new
    def new
      @marketing = Marketing.new
    end

    # GET /marketings/1/edit
    def edit
    end

    # POST /marketings
    def create
      @marketing = Marketing.new(marketing_params)

      if @marketing.save
        redirect(@marketing, params)
      else
        render :new
      end
    end

    # PATCH/PUT /marketings/1
    def update
      if @marketing.update(marketing_params)
        redirect(@marketing, params)
      else
        render :edit
      end
    end

    def clone
      @marketing = Marketing.clone_record params[:marketing_id]

      if @marketing.save
        redirect_to admin_marketings_path
      else
        render :new
      end
    end

    # DELETE /marketings/1
    def destroy
      @marketing.destroy
      redirect_to admin_marketings_path, notice: actions_messages(@marketing)
    end

    def destroy_multiple
      Marketing.destroy redefine_ids(params[:multiple_ids])
      redirect_to(
        admin_marketings_path(page: @current_page, search: @query),
        notice: actions_messages(Marketing.new)
      )
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_marketing
      @marketing = Marketing.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def marketing_params
      params.require(:marketing).permit(:banner, :name, :headline_text, :headline_image, :headline_type, :style_type, :title, :description, :headline_color)
    end

    def show_history
      get_history(Marketing)
    end
  end
end
