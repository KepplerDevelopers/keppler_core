module Admin
  # TestModulesController
  class TestModulesController < AdminController
    before_action :set_test_module, only: [:show, :edit, :update, :destroy]
    before_action :show_history, only: [:index]

    # GET /test_modules
    def index
      @q = TestModule.ransack(params[:q])
      test_modules = @q.result(distinct: true)
      @objects = test_modules.page(@current_page).order(position: :desc)
      @total = test_modules.size
      if !@objects.first_page? && @objects.size.zero?
        redirect_to test_modules_path(page: @current_page.to_i.pred, search: @query)
      end
      respond_to do |format|
        format.html
        format.xls { send_data(@test_modules.to_xls) }
      end
    end

    # GET /test_modules/1
    def show
    end

    # GET /test_modules/new
    def new
      @test_module = TestModule.new
    end

    # GET /test_modules/1/edit
    def edit
    end

    # POST /test_modules
    def create
      @test_module = TestModule.new(test_module_params)

      if @test_module.save
        redirect(@test_module, params)
      else
        render :new
      end
    end

    # PATCH/PUT /test_modules/1
    def update
      if @test_module.update(test_module_params)
        redirect(@test_module, params)
      else
        render :edit
      end
    end

    def clone
      @test_module = TestModule.clone_record params[:test_module_id]

      if @test_module.save
        redirect_to admin_test_modules_path
      else
        render :new
      end
    end

    # DELETE /test_modules/1
    def destroy
      @test_module.destroy
      redirect_to admin_test_modules_path, notice: actions_messages(@test_module)
    end

    def destroy_multiple
      TestModule.destroy redefine_ids(params[:multiple_ids])
      redirect_to(
        admin_test_modules_path(page: @current_page, search: @query),
        notice: actions_messages(TestModule.new)
      )
    end

    def sort
      redirect_to(
        admin_test_modules_path(page: @current_page, search: @query),
        notice: actions_messages(TestModule.new)
      )
    end

    def import
      TestModule.import(params[:file])

      redirect_to(
        admin_test_modules_path(page: @current_page, search: @query),
        notice: actions_messages(TestModule.new)
      )
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_test_module
      @test_module = TestModule.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def test_module_params
      params.require(:test_module).permit(:photo, :name, :phone, :public, :age, :weight)
    end

    def show_history
      get_history(TestModule)
    end
  end
end
