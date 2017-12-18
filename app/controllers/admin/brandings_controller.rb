module Admin
  # BrandingsController
  class BrandingsController < AdminController
    before_action :set_branding, only: [:show, :edit, :update, :destroy]
    before_action :show_history, only: [:index]

    # GET /brandings
    def index
      @q = Branding.ransack(params[:q])
      brandings = @q.result(distinct: true)
      @objects = brandings.page(@current_page)
      @total = brandings.size
      if !@objects.first_page? && @objects.size.zero?
        redirect_to brandings_path(page: @current_page.to_i.pred, search: @query)
      end
      @brandings = Branding.all.reverse
      respond_to do |format|
        format.html
        format.xls { send_data(@brandings.to_xls) }
      end
    end

    # GET /brandings/1
    def show
    end

    # GET /brandings/new
    def new
      @branding = Branding.new
    end

    # GET /brandings/1/edit
    def edit
    end

    # POST /brandings
    def create
      @branding = Branding.new(branding_params)

      if @branding.save
        redirect(@branding, params)
      else
        render :new
      end
    end

    # PATCH/PUT /brandings/1
    def update
      if @branding.update(branding_params)
        redirect(@branding, params)
      else
        render :edit
      end
    end

    def clone
      @branding = Branding.clone_record params[:branding_id]

      if @branding.save
        redirect_to admin_brandings_path
      else
        render :new
      end
    end

    # DELETE /brandings/1
    def destroy
      @branding.destroy
      redirect_to admin_brandings_path, notice: actions_messages(@branding)
    end

    def destroy_multiple
      Branding.destroy redefine_ids(params[:multiple_ids])
      redirect_to(
        admin_brandings_path(page: @current_page, search: @query),
        notice: actions_messages(Branding.new)
      )
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_branding
      @branding = Branding.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def branding_params
      params.require(:branding).permit(:banner, :headline_text, :headline_image, :headline_type, :style_type, :title, :description, :name)
    end

    def show_history
      get_history(Branding)
    end
  end
end
