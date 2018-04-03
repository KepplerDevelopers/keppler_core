module Admin
  # CarsController
  class CarsController < AdminController
    before_action :set_car, only: [:show, :edit, :update, :destroy]
    before_action :show_history, only: [:index]
    before_action :set_attachments

    # GET /cars
    def index
      @q = Car.ransack(params[:q])
      cars = @q.result(distinct: true)
      @objects = cars.page(@current_page).order(position: :desc)
      @total = cars.size
      @cars = @objects.order(:position)
      if !@objects.first_page? && @objects.size.zero?
        redirect_to cars_path(page: @current_page.to_i.pred, search: @query)
      end
    end

    # GET /cars/1
    def show
    end

    # GET /cars/new
    def new
      @car = Car.new
      authorize @car
    end

    # GET /cars/1/edit
    def edit
      authorize @car
    end

    # POST /cars
    def create
      @car = Car.new(car_params)

      if @car.save
        redirect(@car, params)
      else
        render :new
      end
    end

    # PATCH/PUT /cars/1
    def update
      if @car.update(car_params)
        redirect(@car, params)
      else
        render :edit
      end
      authorize @car
    end

    def clone
      @car = Car.clone_record params[:car_id]

      if @car.save
        redirect_to admin_cars_path
      else
        render :new
      end
      authorize @car
    end

    # DELETE /cars/1
    def destroy
      @car.destroy
      redirect_to admin_cars_path, notice: actions_messages(@car)
      authorize @car
    end

    def destroy_multiple
      Car.destroy redefine_ids(params[:multiple_ids])
      redirect_to(
        admin_cars_path(page: @current_page, search: @query),
        notice: actions_messages(Car.new)
      )
      authorize @car
    end

    def import
      Car.import(params[:file])
      redirect_to(
        admin_cars_path(page: @current_page, search: @query),
        notice: actions_messages(Car.new)
      )
      authorize @car
    end

    def download
      @cars = Car.all
      respond_to do |format|
        format.html
        format.xls { send_data(@cars.to_xls) }
        format.json { render :json => @cars }
      end
      authorize @cars
    end

    def reload
      @q = Car.ransack(params[:q])
      cars = @q.result(distinct: true)
      @objects = cars.page(@current_page).order(position: :desc)
    end

    def sort
      Car.sorter(params[:row])
      render :index
    end

    private

    def set_attachments
      @attachments = ['logo', 'brand', 'photo', 'avatar', 'cover', 'image',
                      'picture', 'banner', 'attachment', 'pic', 'file']
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_car
      @car = Car.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def car_params
      params.require(:car).permit(:name, :color, :selled, :photo)
    end

    def show_history
      get_history(Car)
    end
  end
end
