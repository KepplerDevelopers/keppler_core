module Admin
  # MetaTagController
  class MetaTagsController < AdminController
    before_action :set_meta_tag, only: [:show, :edit, :update, :destroy]
    before_action :show_history, only: [:index]

    # GET /meta_tags
    def index
      meta_tags = MetaTag.searching(@query).all
      @objects = meta_tags.page(@current_page)
      @total = meta_tags.size
      if !@objects.first_page? && @objects.size.zero?
        redirect_to meta_tags_path(
          page: @current_page.to_i.pred, search: @query
        )
      end
    end

    # GET /meta_tags/1
    def show
    end

    # GET /meta_tags/new
    def new
      @meta_tag = MetaTag.new
    end

    # GET /meta_tags/1/edit
    def edit
    end

    # POST /meta_tags
    def create
      @meta_tag = MetaTag.new(meta_tag_params)

      if @meta_tag.save
        redirect(@meta_tag, params)
      else
        render :new
      end
    end

    # PATCH/PUT /meta_tags/1
    def update
      if @meta_tag.update(meta_tag_params)
        redirect(@meta_tag, params)
      else
        render :edit
      end
    end

    # DELETE /meta_tags/1
    def destroy
      @meta_tag.destroy
      redirect_to admin_meta_tags_path, notice: actions_messages(@meta_tag)
    end

    def destroy_multiple
      MetaTag.destroy redefine_ids(params[:multiple_ids])
      redirect_to(
        admin_meta_tags_path(page: @current_page, search: @query),
        notice: actions_messages(MetaTag.new)
      )
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_meta_tag
      @meta_tag = MetaTag.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def meta_tag_params
      params.require(:meta_tag).permit(:title, :description, :meta_tags, :url)
    end

    def show_history
      get_history(MetaTag)
    end
  end
end
