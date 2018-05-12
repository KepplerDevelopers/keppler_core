module Admin
  # ScriptsController
  class ScriptsController < AdminController
    before_action :set_ga_track, only: [:show, :edit, :update, :destroy]
    before_action :show_history, only: [:index]
    before_action :authorization # , only: %i[new edit update clone destroy create destroy destroy_multiple import]

    # GET /scripts
    def index
      @q = Script.ransack(params[:q])
      scripts = @q.result(distinct: true)
      @objects = scripts.page(@current_page)
      @total = scripts.size

      if !@objects.first_page? && @objects.size.zero?
        redirect_to scripts_path(page: @current_page.to_i.pred,search: @query)
      end
    end

    # GET /scripts/1
    def show
    end

    # GET /scripts/new
    def new
      @script = Script.new
    end

    # GET /scripts/1/edit
    def edit
    end

    # POST /scripts
    def create
      @script = Script.new(script_params)

      if @script.save
        redirect(@script, params)
      else
        render :new
      end
    end

    # PATCH/PUT /scripts/1
    def update
      if @script.update(script_params)
        redirect(@script, params)
      else
        render :edit
      end
    end

    def clone
      @script = Script.clone_record params[:script_id]

      if @script.save
        redirect_to admin_scripts_path
      else
        render :new
      end
    end

    # DELETE /scripts/1
    def destroy
      @script.destroy

      redirect_to(
        admin_scripts_path,
        notice: actions_messages(@script)
      )
    end

    def destroy_multiple
      Script.destroy redefine_ids(params[:multiple_ids])

      redirect_to(
        admin_scripts_path(page: @current_page, search: @query),
        notice: actions_messages(Script.new)
      )
    end

    def upload
      Script.upload(params[:file])
      redirect_to(
        admin_scripts_path(page: @current_page, search: @query),
        notice: actions_messages(Script.new)
      )
    end

    def download
      @scripts = Script.all
      respond_to do |format|
        format.html
        format.xls { send_data(@scripts.to_xls) }
        format.json { render json: @scripts }
      end
    end

    def reload
      @q = Script.ransack(params[:q])
      scripts = @q.result(distinct: true)
      @objects = scripts.page(@current_page)
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_ga_track
      @script = Script.find(params[:id])
    end

    def authorization
      authorize Script
    end

    # Only allow a trusted parameter "white list" through.
    def script_params
      params.require(:script).permit(:name, :script, :url)
    end

    def show_history
      get_history(Script)
    end
  end
end
