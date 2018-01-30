module Admin
  # RockersController
  class RockersController < AdminController
    before_action :set_rocker, only: [:show, :edit, :update, :destroy]
    before_action :show_history, only: [:index]
    before_action :set_attachments

    # GET /rockers
    def index
      @q = Rocker.ransack(params[:q])
      rockers = @q.result(distinct: true)
      @objects = rockers.page(@current_page).order(position: :desc)
      @total = rockers.size
      @rockers = Rocker.order(:position)
      if !@objects.first_page? && @objects.size.zero?
        redirect_to rockers_path(page: @current_page.to_i.pred, search: @query)
      end
      respond_to do |format|
        format.html
        format.xls { send_data(@rockers.to_xls) }
        format.json { render :json => @objects }
      end
    end

    # GET /rockers/1
    def show
    end

    # GET /rockers/new
    def new
      @rocker = Rocker.new
    end

    # GET /rockers/1/edit
    def edit
    end

    # POST /rockers
    def create
      @rocker = Rocker.new(rocker_params)

      if @rocker.save
        redirect(@rocker, params)
      else
        render :new
      end
    end

    # PATCH/PUT /rockers/1
    def update
      if @rocker.update(rocker_params)
        redirect(@rocker, params)
      else
        render :edit
      end
    end

    def clone
      @rocker = Rocker.clone_record params[:rocker_id]

      if @rocker.save
        redirect_to admin_rockers_path
      else
        render :new
      end
    end

    # DELETE /rockers/1
    def destroy
      @rocker.destroy
      redirect_to admin_rockers_path, notice: actions_messages(@rocker)
    end

    def destroy_multiple
      Rocker.destroy redefine_ids(params[:multiple_ids])
      redirect_to(
        admin_rockers_path(page: @current_page, search: @query),
        notice: actions_messages(Rocker.new)
      )
    end

    def import
      Rocker.import(params[:file])
      redirect_to(
        admin_rockers_path(page: @current_page, search: @query),
        notice: actions_messages(Rocker.new)
      )
    end

    def reload
      @q = Rocker.ransack(params[:q])
      rockers = @q.result(distinct: true)
      @objects = rockers.page(@current_page).order(position: :desc)
    end

    def sort
      Rocker.sorter(params[:row])
      render :index
    end

    private

    def set_attachments
      @attachments = ['logo', 'brand', 'photo', 'avatar', 'cover', 'image',
                      'picture', 'banner', 'attachment', 'pic', 'file']
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_rocker
      @rocker = Rocker.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def rocker_params
      params.require(:rocker).permit(:avatar, :name)
    end

    def show_history
      get_history(Rocker)
    end
  end
end
