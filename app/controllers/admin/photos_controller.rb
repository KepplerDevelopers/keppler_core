module Admin
  # PhotosController
  class PhotosController < AdminController
    before_action :set_photo, only: [:show, :edit, :update, :destroy]
    before_action :show_history, only: [:index]
    before_action :set_gallery


    # GET /photos
    def index
      @q = Photo.ransack(@gallery_photo)
      photos = @q.result(distinct: true).where(gallery_id: @gallery_photo)
      @objects = photos.page(@current_page).order(position: :desc)
      @total = photos.size
      if !@objects.first_page? && @objects.size.zero?
        redirect_to photos_path(page: @current_page.to_i.pred, search: @query)
      end
      respond_to do |format|
        format.html
        format.xls { send_data(@photos.to_xls) }
      end
    end

    # GET /photos/1
    def show
    end

    # GET /photos/new
    def new
      @photo = Photo.new(gallery_id: params[:gallery_id])
    end

    # GET /photos/1/edit
    def edit
    end

    # POST /photos
    def create
      @photo = Photo.new(photo_params)

      if @photo.save
        if params.key?('_add_other')
          redirect_to new_admin_gallery_photo_path, notice: actions_messages(@photo)
        else
          redirect_to admin_gallery_photos_path
        end
      else
        render :new
      end
    end

    # PATCH/PUT /photos/1
    def update
      if @photo.update(photo_params)
        if params.key?('_add_other')
          redirect_to new_admin_gallery_photo_path, notice: actions_messages(@photo)
        else
          redirect_to admin_gallery_photos_path
        end
      else
        render :edit
      end
    end

    def clone
      @photo = Photo.clone_record params[:photo_id]

      if @photo.save
        redirect_to admin_gallery_photos_path
      else
        render :new
      end
    end

    # DELETE /photos/1
    def destroy
      @photo.destroy
      redirect_to admin_gallery_photos_path, notice: actions_messages(@photo)
    end

    def destroy_multiple
      Photo.destroy redefine_ids(params[:multiple_ids])
      redirect_to(
        admin_gallery_photos_path(page: @current_page, search: @query),
        notice: actions_messages(Photo.new)
      )
    end

    def import
      Photo.import(params[:file])

      redirect_to(
        admin_gallery_photos_path(page: @current_page, search: @query),
        notice: actions_messages(Photo.new)
      )
    end

    private

    def set_gallery
      @gallery_photo = Gallery.find(params[:gallery_id])
    end


    # Use callbacks to share common setup or constraints between actions.
    def set_photo
      @photo = Photo.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def photo_params
      params.require(:photo).permit(:photo, :gallery_id)
    end

    def show_history
      get_history(Photo)
    end
  end
end
