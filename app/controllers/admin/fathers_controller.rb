module Admin
  # FathersController
  class FathersController < AdminController
    before_action :set_father, only: [:show, :edit, :update, :destroy]
    before_action :show_history, only: [:index]
    before_action :set_attachments

    # GET /fathers
    def index
      @q = Father.ransack(params[:q])
      fathers = @q.result(distinct: true)
      @objects = fathers.page(@current_page).order(position: :desc)
      @total = fathers.size
      @fathers = Father.order(:position)
      if !@objects.first_page? && @objects.size.zero?
        redirect_to fathers_path(page: @current_page.to_i.pred, search: @query)
      end
      respond_to do |format|
        format.html
        format.xls { send_data(@fathers.to_xls) }
        format.json { render :json => @objects }
      end
    end

    # GET /fathers/1
    def show
    end

    # GET /fathers/new
    def new
      @father = Father.new
    end

    # GET /fathers/1/edit
    def edit
    end

    # POST /fathers
    def create
      @father = Father.new(father_params)

      if @father.save
        redirect(@father, params)
      else
        render :new
      end
    end

    # PATCH/PUT /fathers/1
    def update
      if @father.update(father_params)
        redirect(@father, params)
      else
        render :edit
      end
    end

    def clone
      @father = Father.clone_record params[:father_id]

      if @father.save
        redirect_to admin_fathers_path
      else
        render :new
      end
    end

    # DELETE /fathers/1
    def destroy
      @father.destroy
      redirect_to admin_fathers_path, notice: actions_messages(@father)
    end

    def destroy_multiple
      Father.destroy redefine_ids(params[:multiple_ids])
      redirect_to(
        admin_fathers_path(page: @current_page, search: @query),
        notice: actions_messages(Father.new)
      )
    end

    def import
      Father.import(params[:file])
      redirect_to(
        admin_fathers_path(page: @current_page, search: @query),
        notice: actions_messages(Father.new)
      )
    end

    def reload
      @q = Father.ransack(params[:q])
      fathers = @q.result(distinct: true)
      @objects = fathers.page(@current_page).order(position: :desc)
    end

    def sort
      Father.sorter(params[:row])
      render :index
    end

    private

    def set_attachments
      @attachments = ['logo', 'brand', 'photo', 'avatar', 'cover', 'image',
                      'picture', 'banner', 'attachment', 'pic', 'file']
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_father
      @father = Father.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def father_params
      params.require(:father).permit(:avatar, :name, :email, :icon, :logo)
    end

    def show_history
      get_history(Father)
    end
  end
end
