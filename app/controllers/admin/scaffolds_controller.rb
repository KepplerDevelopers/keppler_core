module Admin
  # ScaffoldsController
  class ScaffoldsController < AdminController
    before_action :set_scaffold, only: [:show, :edit, :update, :destroy]
    before_action :show_history, only: [:index]

    # GET /scaffolds
    def index
      @q = Scaffold.ransack(params[:q])
      scaffolds = @q.result(distinct: true)
      @objects = scaffolds.page(@current_page)
      @total = scaffolds.size
      if !@objects.first_page? && @objects.size.zero?
        redirect_to scaffolds_path(page: @current_page.to_i.pred, search: @query)
      end
      @scaffolds = Scaffold.all.reverse
      respond_to do |format|
        format.html
        format.xls { send_data(@scaffolds.to_xls) }
      end
    end

    # GET /scaffolds/1
    def show
    end

    # GET /scaffolds/new
    def new
      @scaffold = Scaffold.new
    end

    # GET /scaffolds/1/edit
    def edit
    end

    # POST /scaffolds
    def create
      fields = params[:fields].split(',').join(' ')
      system "rails g keppler_scaffold #{params[:scaffold][:name]} #{fields}"
      system "rake db:migrate"

      @scaffold = Scaffold.new(scaffold_params)

      if @scaffold.save
        redirect(@scaffold, params)
      else
        render :new
      end
    end

    # PATCH/PUT /scaffolds/1
    def update
      if @scaffold.update(scaffold_params)
        redirect(@scaffold, params)
      else
        render :edit
      end
    end

    def clone
      @scaffold = Scaffold.clone_record params[:scaffold_id]

      if @scaffold.save
        redirect_to admin_scaffolds_path
      else
        render :new
      end
    end

    # DELETE /scaffolds/1
    def destroy
      @scaffold.destroy
      redirect_to admin_scaffolds_path, notice: actions_messages(@scaffold)
    end

    def destroy_multiple
      Scaffold.destroy redefine_ids(params[:multiple_ids])
      redirect_to(
        admin_scaffolds_path(page: @current_page, search: @query),
        notice: actions_messages(Scaffold.new)
      )
    end

    def import
      Scaffold.import(params[:file])

      redirect_to(
        admin_scaffolds_path(page: @current_page, search: @query),
        notice: actions_messages(Scaffold.new)
      )
    end

    private

    # def fields(fields)
    #   fields.each_with_index do |el , index|
    #     if idex.even?
    #       return "#{el}:#{fields[index+1]}"
    #     end
    #   end
    # end

    # Use callbacks to share common setup or constraints between actions.
    def set_scaffold
      @scaffold = Scaffold.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def scaffold_params
      params.require(:scaffold).permit(:name, :fields)
    end

    def show_history
      get_history(Scaffold)
    end
  end
end
