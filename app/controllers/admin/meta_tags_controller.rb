module Admin
  # MetaTagController
  class MetaTagsController < AdminController
    before_action :set_meta_tag, only: [:show, :edit, :update, :destroy]
    before_action :show_history, only: [:index]

    # GET /meta_tags
    def index
      @q = MetaTag.ransack(params[:q])
      meta_tags = @q.result(distinct: true).order(:position)
      @objects = meta_tags.page(@current_page)
      @total = meta_tags.size
      if !@objects.first_page? && @objects.size.zero?
        redirect_to meta_tags_path(page: @current_page.to_i.pred,search: @query)
      end
    end

    # GET /meta_tags/1
    def show
    end

    # GET /meta_tags/new
    def new
      @meta_tag = MetaTag.new
      authorize @meta_tag
    end

    # GET /meta_tags/1/edit
    def edit
      authorize @meta_tag
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
      authorize @meta_tag
    end

    def clone
      @meta_tag = MetaTag.clone_record params[:meta_tag_id]

      if @meta_tag.save
        redirect_to admin_meta_tags_path
      else
        render :new
      end
      authorize @meta_tag
    end

    # DELETE /meta_tags/1
    def destroy
      @meta_tag.destroy
      redirect_to admin_meta_tags_path, notice: actions_messages(@meta_tag)
      authorize @meta_tag
    end

    def destroy_multiple
      MetaTag.destroy redefine_ids(params[:multiple_ids])
      redirect_to(
        admin_meta_tags_path(page: @current_page, search: @query),
        notice: actions_messages(MetaTag.new)
      )
      authorize @meta_tag
    end

    def import
      MetaTag.import(params[:file])
      redirect_to(
        admin_meta_tags_path(page: @current_page, search: @query),
        notice: actions_messages(MetaTag.new)
      )
      authorize @meta_tag
    end

    def download
      @meta_tags = MetaTag.all
      respond_to do |format|
        format.html
        format.xls { send_data(@meta_tags.to_xls) }
        format.json { render :json => @meta_tags }
      end
      authorize @meta_tags
    end

    def reload
      @meta_tags = MetaTag.order(:position)
    end

    def sort
      MetaTag.sorter(params[:row])
      render :index
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_meta_tag
      @meta_tag = MetaTag.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def meta_tag_params
      params.require(:meta_tag).permit(:title, :description, :meta_tags, :url, :position)
    end

    def show_history
      get_history(MetaTag)
    end
  end
end
