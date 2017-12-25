module Admin
  # WebsController
  class WebsController < AdminController
    before_action :set_web, only: [:show, :edit, :update, :destroy]
    before_action :show_history, only: [:index]

    # GET /webs
    def index
      @q = Web.ransack(params[:q])
      webs = @q.result(distinct: true)
      @objects = webs.page(@current_page)
      @total = webs.size
      if !@objects.first_page? && @objects.size.zero?
        redirect_to webs_path(page: @current_page.to_i.pred, search: @query)
      end
      @webs = Web.all.reverse
      respond_to do |format|
        format.html
        format.xls { send_data(@webs.to_xls) }
      end
    end

    # GET /webs/1
    def show
    end

    # GET /webs/new
    def new
      @web = Web.new
    end

    # GET /webs/1/edit
    def edit
    end

    # POST /webs
    def create
      @web = Web.new(web_params)

      if @web.save
        redirect(@web, params)
      else
        render :new
      end
    end

    # PATCH/PUT /webs/1
    def update
      if @web.update(web_params)
        redirect(@web, params)
      else
        render :edit
      end
    end

    def clone
      @web = Web.clone_record params[:web_id]

      if @web.save
        redirect_to admin_webs_path
      else
        render :new
      end
    end

    # DELETE /webs/1
    def destroy
      @web.destroy
      redirect_to admin_webs_path, notice: actions_messages(@web)
    end

    def destroy_multiple
      Web.destroy redefine_ids(params[:multiple_ids])
      redirect_to(
        admin_webs_path(page: @current_page, search: @query),
        notice: actions_messages(Web.new)
      )
    end

    def import
      Web.import(params[:file])

      redirect_to(
        admin_webs_path(page: @current_page, search: @query),
        notice: actions_messages(Web.new)
      )
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_web
      @web = Web.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def web_params
      params.require(:web).permit(:name, :description, :date, :pay)
    end

    def show_history
      get_history(Web)
    end
  end
end
