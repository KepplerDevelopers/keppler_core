module Admin
  # EstablishmentsController
  class EstablishmentsController < AdminController
    before_action :set_establishment, only: [:show, :edit, :update, :destroy]
    before_action :show_history, only: [:index]

    # GET /establishments
    def index
      @q = Establishment.ransack(params[:q])
      establishments = @q.result(distinct: true)
      @objects = establishments.page(@current_page)
      @total = establishments.size
      if !@objects.first_page? && @objects.size.zero?
        redirect_to establishments_path(page: @current_page.to_i.pred, search: @query)
      end
      @establishments = Establishment.all.reverse
      respond_to do |format|
        format.html
        format.xls { send_data(@establishments.to_xls) }
      end
    end

    # GET /establishments/1
    def show
    end

    # GET /establishments/new
    def new
      @establishment = Establishment.new
    end

    # GET /establishments/1/edit
    def edit
    end

    # POST /establishments
    def create
      @establishment = Establishment.new(establishment_params)

      if @establishment.save
        redirect(@establishment, params)
      else
        render :new
      end
    end

    # PATCH/PUT /establishments/1
    def update
      if @establishment.update(establishment_params)
        redirect(@establishment, params)
      else
        render :edit
      end
    end

    def clone
      @establishment = Establishment.clone_record params[:establishment_id]

      if @establishment.save
        redirect_to admin_establishments_path
      else
        render :new
      end
    end

    # DELETE /establishments/1
    def destroy
      @establishment.destroy
      redirect_to admin_establishments_path, notice: actions_messages(@establishment)
    end

    def destroy_multiple
      Establishment.destroy redefine_ids(params[:multiple_ids])
      redirect_to(
        admin_establishments_path(page: @current_page, search: @query),
        notice: actions_messages(Establishment.new)
      )
    end

    def import
      Establishment.import(params[:file])

      redirect_to(
        admin_establishments_path(page: @current_page, search: @query),
        notice: actions_messages(Establishment.new)
      )
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_establishment
      @establishment = Establishment.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def establishment_params
      params.require(:establishment).permit(:name, :city, :email)
    end

    def show_history
      get_history(Establishment)
    end
  end
end
