#Generado con Keppler.
class MetaTagsController < ApplicationController  
  before_filter :authenticate_user!
  layout 'admin/application'
  load_and_authorize_resource
  before_action :set_meta_tag, only: [:show, :edit, :update, :destroy]
  before_action :show_history, only: [:index]

  # GET /meta_tags
  def index
    meta_tags = MetaTag.searching(@query).all
    @objects, @total = meta_tags.page(@current_page), meta_tags.size
    redirect_to meta_tags_path(page: @current_page.to_i.pred, search: @query) if !@objects.first_page? and @objects.size.zero?
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
      redirect_to @meta_tag, notice: t('keppler.messages.successfully.created', model: t("keppler.models.singularize.meta_tag").humanize) 
    else
      render :new
    end
  end

  # PATCH/PUT /meta_tags/1
  def update
    if @meta_tag.update(meta_tag_params)
      redirect_to @meta_tag, notice: t('keppler.messages.successfully.updated', model: t("keppler.models.singularize.meta_tag").humanize) 
    else
      render :edit
    end
  end

  # DELETE /meta_tags/1
  def destroy
    @meta_tag.destroy
    redirect_to meta_tags_url, notice: t('keppler.messages.successfully.deleted', model: t("keppler.models.singularize.meta_tag").humanize) 
  end

  def destroy_multiple
    MetaTag.destroy redefine_ids(params[:multiple_ids])
    redirect_to meta_tags_path(page: @current_page, search: @query), notice: t('keppler.messages.successfully.removed', model: t("keppler.models.singularize.meta_tag").humanize) 
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
      if current_user.has_role? :admin
        @activities = PublicActivity::Activity.where(trackable_type: 'MetaTag').order("created_at desc").limit(50)
      else
        @activities = PublicActivity::Activity.where("trackable_type = 'MetaTag' and owner_id=#{current_user.id}").order("created_at desc").limit(50)
      end
    end
end
