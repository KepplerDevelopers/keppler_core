module Admin
  # ProyectsController
  class ProyectsController < AdminController
    before_action :set_proyect, only: [:show, :edit, :update, :destroy]
    before_action :show_history, only: [:index]

    # GET /proyects
    def index
      @q = Proyect.ransack(params[:q])
      proyects = @q.result(distinct: true)
      @objects = proyects.page(@current_page)
      @total = proyects.size
      if !@objects.first_page? && @objects.size.zero?
        redirect_to proyects_path(page: @current_page.to_i.pred, search: @query)
      end
      @proyects = Proyect.all.reverse
      respond_to do |format|
        format.html
        format.xls { send_data(@proyects.to_xls) }
      end
    end

    # GET /proyects/1
    def show
    end

    # GET /proyects/new
    def new
      @proyect = Proyect.new
    end

    # GET /proyects/1/edit
    def edit
    end

    # POST /proyects
    def create
      @proyect = Proyect.new(proyect_params)

      if @proyect.save
        redirect(@proyect, params)
      else
        render :new
      end
    end

    # PATCH/PUT /proyects/1
    def update
      if @proyect.update(proyect_params)
        redirect(@proyect, params)
      else
        render :edit
      end
    end

    def clone
      @proyect = Proyect.clone_record params[:proyect_id]

      if @proyect.save
        redirect_to admin_proyects_path
      else
        render :new
      end
    end

    # DELETE /proyects/1
    def destroy
      @proyect.destroy
      redirect_to admin_proyects_path, notice: actions_messages(@proyect)
    end

    def destroy_multiple
      Proyect.destroy redefine_ids(params[:multiple_ids])
      redirect_to(
        admin_proyects_path(page: @current_page, search: @query),
        notice: actions_messages(Proyect.new)
      )
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_proyect
      @proyect = Proyect.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def proyect_params
      params.require(:proyect).permit(:banner, :headline, :service_type, :description, :name, :share, :brand)
    end

    def show_history
      get_history(Proyect)
    end
  end
end
