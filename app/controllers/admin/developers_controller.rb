module Admin
  # DevelopersController
  class DevelopersController < AdminController
    before_action :set_developer, only: [:show, :edit, :update, :destroy]
    before_action :show_history, only: [:index]

    # GET /developers
    def index
      @q = Developer.ransack(params[:q])
      developers = @q.result(distinct: true)
      @objects = developers.page(@current_page)
      @total = developers.size
      if !@objects.first_page? && @objects.size.zero?
        redirect_to developers_path(page: @current_page.to_i.pred, search: @query)
      end
      @developers = Developer.all
      respond_to do |format|
        format.html
        format.xls { send_data(@developers.to_xls) }
      end
    end

    # GET /developers/1
    def show
    end

    # GET /developers/new
    def new
      @developer = Developer.new
    end

    # GET /developers/1/edit
    def edit
    end

    # POST /developers
    def create
      @developer = Developer.new(developer_params)

      if @developer.save
        redirect(@developer, params)
      else
        render :new
      end
    end

    # PATCH/PUT /developers/1
    def update
      if @developer.update(developer_params)
        redirect(@developer, params)
      else
        render :edit
      end
    end

    def clone
      @developer = Developer.clone_record params[:developer_id]

      if @developer.save
        redirect_to admin_developers_path
      else
        render :new
      end
    end

    # DELETE /developers/1
    def destroy
      @developer.destroy
      redirect_to admin_developers_path, notice: actions_messages(@developer)
    end

    def destroy_multiple
      Developer.destroy redefine_ids(params[:multiple_ids])
      redirect_to(
        admin_developers_path(page: @current_page, search: @query),
        notice: actions_messages(Developer.new)
      )
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_developer
      @developer = Developer.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def developer_params
      params.require(:developer).permit(:avatar, :name)
    end

    def show_history
      get_history(Developer)
    end
  end
end
