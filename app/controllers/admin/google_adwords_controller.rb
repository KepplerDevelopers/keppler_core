module Admin
  # GoogleAdwordsController
  class GoogleAdwordsController < AdminController
    before_action :set_google_adword, only: [:show, :edit, :update, :destroy]
    before_action :show_history, only: [:index]

    # GET /google_adwords
    def index
      @q = GoogleAdword.ransack(params[:q])
      google_adwords = @q.result(distinct: true)
      @objects = google_adwords.page(@current_page)
      @total = google_adwords.size
      if !@objects.first_page? && @objects.size.zero?
        redirect_to(
          google_adwords_path(page: @current_page.to_i.pred, search: @query)
        )
      end
    end

    # GET /google_adwords/1
    def show
    end

    # GET /google_adwords/new
    def new
      @google_adword = GoogleAdword.new
    end

    # GET /google_adwords/1/edit
    def edit
    end

    # POST /google_adwords
    def create
      @google_adword = GoogleAdword.new(google_adword_params)

      if @google_adword.save
        redirect(@google_adword, params)
      else
        render :new
      end
    end

    # PATCH/PUT /google_adwords/1
    def update
      if @google_adword.update(google_adword_params)
        redirect(@google_adword, params)
      else
        render :edit
      end
    end

    def clone
      @google_adword = GoogleAdword.clone_record params[:google_adword_id]

      if @google_adword.save
        redirect_to admin_meta_tags_path
      else
        render :new
      end
    end

    # DELETE /google_adwords/1
    def destroy
      @google_adword.destroy
      redirect_to(
        admin_google_adwords_path, notice: actions_messages(@google_adword)
      )
    end

    def destroy_multiple
      GoogleAdword.destroy redefine_ids(params[:multiple_ids])
      redirect_to(
        admin_google_adwords_path(page: @current_page, search: @query),
        notice: actions_messages(GoogleAdword.new)
      )
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_google_adword
      @google_adword = GoogleAdword.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def google_adword_params
      params.require(:google_adword).permit(
        :url, :campaign_name, :description, :script
      )
    end

    def show_history
      get_history(GoogleAdword)
    end
  end
end
