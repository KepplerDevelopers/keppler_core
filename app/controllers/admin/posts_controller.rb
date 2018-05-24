module Admin
  # PostsController
  class PostsController < AdminController
    before_action :set_post, only: %i[show edit update destroy]
    before_action :show_history, only: %i[index]
    before_action :set_attachments
    before_action :authorization

    # GET /posts
    def index
      @q = Post.ransack(params[:q])
      posts = @q.result(distinct: true)
      @objects = posts.page(@current_page).order(position: :desc)
      @total = posts.size
      @posts = @objects.order(:position)
      if !@objects.first_page? && @objects.size.zero?
        redirect_to posts_path(page: @current_page.to_i.pred, search: @query)
      end
      format
    end

    # GET /posts/1
    def show; end

    # GET /posts/new
    def new
      @post = Post.new
    end

    # GET /posts/1/edit
    def edit; end

    # POST /posts
    def create
      @post = Post.new(post_params)

      if @post.save
        redirect(@post, params)
      else
        render :new
      end
    end

    # PATCH/PUT /posts/1
    def update
      if @post.update(post_params)
        redirect(@post, params)
      else
        render :edit
      end
    end

    def clone
      @post = Post.clone_record params[:post_id]

      if @post.save
        redirect_to admin_posts_path
      else
        render :new
      end
    end

    # DELETE /posts/1
    def destroy
      @post.destroy
      redirect_to admin_posts_path, notice: actions_messages(@post)
    end

    def destroy_multiple
      Post.destroy redefine_ids(params[:multiple_ids])
      redirect_to(
        admin_posts_path(page: @current_page, search: @query),
        notice: actions_messages(Post.new)
      )
    end

    def upload
      Post.upload(params[:file])
      redirect_to(
        admin_posts_path(page: @current_page, search: @query),
        notice: actions_messages(Post.new)
      )
    end

    def reload
      @q = Post.ransack(params[:q])
      posts = @q.result(distinct: true)
      @objects = posts.page(@current_page).order(position: :desc)
    end

    def sort
      Post.sorter(params[:row])
      render :index
    end

    private

    def format
      respond_to do |format|
        format.html
        format.csv { send_data @posts.to_csv }
        format.xls # { send_data @posts.to_xls }
        format.json { render json: @posts }
      end
    end

    def authorization
      authorize Post
    end

    def set_attachments
      @attachments = ['logo', 'brand', 'photo', 'avatar', 'cover', 'image',
                      'picture', 'banner', 'attachment', 'pic', 'file']
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def post_params
      params.require(:post).permit(:image, :name, :body, :position, :deleted_at)
    end

    def show_history
      get_history(Post)
    end
  end
end
