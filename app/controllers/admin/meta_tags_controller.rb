# frozen_string_literal: true

module Admin
  # MetaTagController
  class MetaTagsController < AdminController
    before_action :set_meta_tag, only: %i[show edit update destroy]
    before_action :show_history, only: %i[index]
    before_action :authorization, except: %i[reload]
    include ObjectQuery

    # GET /meta_tags
    def index
      @q = MetaTag.ransack(params[:q])
      @meta_tags = @q.result(distinct: true)
      @objects = @meta_tags.page(@current_page).order(position: :desc)
      @total = @meta_tags.size
      redirect_to_index(meta_tags_path) if nothing_in_first_page?(@objects)
      respond_to_formats(@meta_tags)
    end

    # GET /meta_tags/1
    def show; end

    # GET /meta_tags/new
    def new
      @meta_tag = MetaTag.new
    end

    # GET /meta_tags/1/edit
    def edit; end

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

    def clone
      @meta_tag = MetaTag.clone_record params[:meta_tag_id]

      if @meta_tag.save
        redirect_to admin_meta_tags_path
      else
        render :new
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

    def upload
      MetaTag.upload(params[:file])
      redirect_to(
        admin_meta_tags_path(page: @current_page, search: @query),
        notice: actions_messages(MetaTag.new)
      )
    end

    def download
      @meta_tags = MetaTag.all
      respond_to_formats(@meta_tags)
    end

    def reload
      @objects = MetaTag.order(:position)
    end

    def sort
      MetaTag.sorter(params[:row])
      render :index
    end

    private

    def authorization
      authorize MetaTag
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_meta_tag
      @meta_tag = MetaTag.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def meta_tag_params
      params.require(:meta_tag).permit(:title, :description,
                                       :meta_tags, :url, :position)
    end

    def show_history
      get_history(MetaTag)
    end
  end
end
