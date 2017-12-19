module Admin
  # BriefingsController
  class BriefingsController < AdminController
    before_action :set_briefing, only: [:show, :edit, :update, :destroy]
    before_action :show_history, only: [:index]

    # GET /briefings
    def index
      @q = Briefing.ransack(params[:q])
      briefings = @q.result(distinct: true)
      @objects = briefings.page(@current_page)
      @total = briefings.size
      if !@objects.first_page? && @objects.size.zero?
        redirect_to briefings_path(page: @current_page.to_i.pred, search: @query)
      end
      @briefings = Briefing.all.reverse
      respond_to do |format|
        format.html
        format.xls { send_data(@briefings.to_xls) }
      end
    end

    # GET /briefings/1
    def show
    end

    # GET /briefings/new
    def new
      @briefing = Briefing.new
    end

    # GET /briefings/1/edit
    def edit
    end

    # POST /briefings
    def create
      @briefing = Briefing.new(briefing_params)

      if @briefing.save
        redirect_to root_path
      else
        render :new
      end
    end

    # PATCH/PUT /briefings/1
    def update
      if @briefing.update(briefing_params)
        redirect(@briefing, params)
      else
        render :edit
      end
    end

    def clone
      @briefing = Briefing.clone_record params[:briefing_id]

      if @briefing.save
        redirect_to admin_briefings_path
      else
        render :new
      end
    end

    # DELETE /briefings/1
    def destroy
      @briefing.destroy
      redirect_to admin_briefings_path, notice: actions_messages(@briefing)
    end

    def destroy_multiple
      Briefing.destroy redefine_ids(params[:multiple_ids])
      redirect_to(
        admin_briefings_path(page: @current_page, search: @query),
        notice: actions_messages(Briefing.new)
      )
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_briefing
      @briefing = Briefing.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def briefing_params
      params.require(:briefing).permit(:name, :email, :phone, :company, :services_type, :other, :about)
    end

    def show_history
      get_history(Briefing)
    end
  end
end
