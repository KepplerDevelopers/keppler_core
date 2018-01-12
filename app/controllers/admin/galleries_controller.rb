module Admin
  # GalleriesController
  class GalleriesController < AdminController
    before_action :set_gallery, only: [:show, :edit, :update, :destroy]
    before_action :show_history, only: [:index]

    # GET /galleries
    def index
      @q = Gallery.ransack(params[:q])
      galleries = @q.result(distinct: true)
      @objects = galleries.page(@current_page).order(position: :desc)
      @total = galleries.size
      if !@objects.first_page? && @objects.size.zero?
        redirect_to galleries_path(page: @current_page.to_i.pred, search: @query)
      end
      respond_to do |format|
        format.html
        format.xls { send_data(@galleries.to_xls) }
      end
    end

    # GET /galleries/1
    def show
    end

    # GET /galleries/new
    def new
      @gallery = Gallery.new
    end

    # GET /galleries/1/edit
    def edit
    end

    # POST /galleries
    def create
      @gallery = Gallery.new(gallery_params)

      if @gallery.save
        redirect(@gallery, params)
      else
        render :new
      end
    end

    # PATCH/PUT /galleries/1
    def update
      if @gallery.update(gallery_params)
        redirect(@gallery, params)
      else
        render :edit
      end
    end

    def clone
      @gallery = Gallery.clone_record params[:gallery_id]

      if @gallery.save
        redirect_to admin_galleries_path
      else
        render :new
      end
    end

    # DELETE /galleries/1
    def destroy
      @gallery.destroy
      redirect_to admin_galleries_path, notice: actions_messages(@gallery)
    end

    def destroy_multiple
      Gallery.destroy redefine_ids(params[:multiple_ids])
      redirect_to(
        admin_galleries_path(page: @current_page, search: @query),
        notice: actions_messages(Gallery.new)
      )
    end

    def import
      Gallery.import(params[:file])

      redirect_to(
        admin_galleries_path(page: @current_page, search: @query),
        notice: actions_messages(Gallery.new)
      )
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_gallery
      @gallery = Gallery.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def gallery_params
      params.require(:gallery).permit(:name)
    end

    def show_history
      get_history(Gallery)
    end
  end
end
