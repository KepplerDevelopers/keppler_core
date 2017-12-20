module Admin
  # TermsAndConditionsController
  class TermsAndConditionsController < AdminController
    before_action :set_terms_and_condition, only: [:show, :edit, :update, :destroy]
    before_action :show_history, only: [:index]

    # GET /terms_and_conditions
    def index
      @q = TermsAndCondition.ransack(params[:q])
      terms_and_conditions = @q.result(distinct: true)
      @objects = terms_and_conditions.page(@current_page)
      @total = terms_and_conditions.size
      if !@objects.first_page? && @objects.size.zero?
        redirect_to terms_and_conditions_path(page: @current_page.to_i.pred, search: @query)
      end
      @terms_and_conditions = TermsAndCondition.all.reverse
      respond_to do |format|
        format.html
        format.xls { send_data(@terms_and_conditions.to_xls) }
      end
    end

    # GET /terms_and_conditions/1
    def show
    end

    # GET /terms_and_conditions/new
    def new
      @terms_and_condition = TermsAndCondition.new
    end

    # GET /terms_and_conditions/1/edit
    def edit
    end

    # POST /terms_and_conditions
    def create
      @terms_and_condition = TermsAndCondition.new(terms_and_condition_params)

      if @terms_and_condition.save
        redirect(@terms_and_condition, params)
      else
        render :new
      end
    end

    # PATCH/PUT /terms_and_conditions/1
    def update
      if @terms_and_condition.update(terms_and_condition_params)
        redirect(@terms_and_condition, params)
      else
        render :edit
      end
    end

    def clone
      @terms_and_condition = TermsAndCondition.clone_record params[:terms_and_condition_id]

      if @terms_and_condition.save
        redirect_to admin_terms_and_conditions_path
      else
        render :new
      end
    end

    # DELETE /terms_and_conditions/1
    def destroy
      @terms_and_condition.destroy
      redirect_to admin_terms_and_conditions_path, notice: actions_messages(@terms_and_condition)
    end

    def destroy_multiple
      TermsAndCondition.destroy redefine_ids(params[:multiple_ids])
      redirect_to(
        admin_terms_and_conditions_path(page: @current_page, search: @query),
        notice: actions_messages(TermsAndCondition.new)
      )
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_terms_and_condition
      @terms_and_condition = TermsAndCondition.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def terms_and_condition_params
      params.require(:terms_and_condition).permit(:content)
    end

    def show_history
      get_history(TermsAndCondition)
    end
  end
end
