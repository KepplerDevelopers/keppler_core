module Admin
  # CustomizesController
  class CustomizesController < AdminController
    before_action :set_customize, only: %i[show edit update destroy authorization]
    before_action :set_customizes, only: %i[update install_default]
    before_action :show_history, only: %i[index]
    before_action :authorization, only: %i[
      new create edit update destroy destroy_multiple
    ]

    # GET /customizes
    def index
      @q = Customize.ransack(params[:q])
      customizes = @q.result(distinct: true)
      @objects = customizes.page(@current_page)
      @total = customizes.size
      if !@objects.first_page? && @objects.blank?
        redirect_to customizes_path(
          page: @current_page.to_i.pred, search: @query
        )
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

    # PATCH/PUT /customizes/1
    def update
      @customizes.each { |customize| customize.update(installed: false) }
      if @customize.update(customize_params)
        @customize.installed? ? @customize.install : @customize.uninstall
        redirect_to admin_customizes_path
      else
        render :edit
      end
    end

    def install_default
      @customize = Customize.find(params[:customize_id])
      if @customize.installed?
        redirect_to admin_customizes_path
      else
        @customizes.each { |customize| customize.update(installed: false) }
        if @customize.update(customize_params)
          @customize.install_keppler_template
          redirect_to admin_customizes_path
        else
          render :edit
        end
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

    def set_customizes
      @customizes = Customize.all
    end

    def authorization
      authorize Customize
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
