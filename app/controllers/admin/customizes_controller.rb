module Admin
  # CustomizesController
  class CustomizesController < AdminController
    before_action :set_customize, only: [:show, :edit, :update, :destroy]
    before_action :show_history, only: [:index]

    # GET /customizes
    def index
      @q = Customize.ransack(params[:q])
      customizes = @q.result(distinct: true)
      @objects = customizes.page(@current_page)
      @total = customizes.size
      if !@objects.first_page? && @objects.size.zero?
        redirect_to customizes_path(page: @current_page.to_i.pred, search: @query)
      end
    end

    # GET /customizes/new
    def new
      @customize = Customize.new
    end

    # POST /customizes
    def create
      @customize = Customize.new(customize_params)
      @customize.installed = false

      if @customize.save
        redirect_to admin_customizes_path
      else
        render :new
      end
    end

    def install_default
      @customize = Customize.find(params[:customize_id])
      if !@customize.installed?
        @customizes = Customize.all
        @customizes.each { |customize| customize.update(installed: false) }
        if @customize.update(customize_params)
          @customize.install_keppler_template
          redirect_to :back
        else
          render :edit
        end
      else
        redirect_to :back
      end
    end
    
    # DELETE /customizes/1
    def destroy
      if @customize.installed?
        @customize.install
      end
      @customize.destroy
      redirect_to admin_customizes_path, notice: actions_messages(@customize)
    end

    def destroy_multiple
      Customize.destroy redefine_ids(params[:multiple_ids])
      redirect_to(
        admin_customizes_path(page: @current_page, search: @query),
        notice: actions_messages(Customize.new)
      )
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_customize
      @customize = Customize.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def customize_params
      params.require(:customize).permit(:file, :installed)
    end

    def show_history
      get_history(Customize)
    end

  end
end
