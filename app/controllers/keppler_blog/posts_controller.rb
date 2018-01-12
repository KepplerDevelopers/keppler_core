# Generado con Keppler.
require_dependency 'keppler_blog/application_controller'

module KepplerBlog
  class PostsController < Admin::AdminController
    before_filter :authenticate_user!
    layout 'admin/layouts/application'
    load_and_authorize_resource except: [:subcategories_of_cagegory]
    before_action :set_post, only: [:show, :edit, :update, :destroy]
    before_action :set_categories, only: [:new, :edit, :update, :create]
    before_action :show_history, only: [:index]

    # GET /posts
    def index
      @q = Post.ransack(params[:q])
      posts = @q.result(distinct: true)
      posts = posts.where(user_id: current_user.id) if current_user.has_role?(:autor)
      @objects = posts.page(@current_page)
      @total = posts.size

      if !@objects.first_page? && @objects.size.zero?
        redirect_to(
          posts_path(page: @current_page.to_i.pred, search: @query)
        )
      end
    end

    # GET /posts/1
    def show
    end

    # GET /posts/new
    def new
      @post = Post.new
    end

    # GET /posts/1/edit
    def edit
    end

    # POST /posts
    def create
      @post = Post.new(post_params.merge(user_id: current_user.id))

      if @post.save
        redirect(@post, params)
      else
        render :new
      end
    end

    # PATCH/PUT /posts/1
    def update
      @post.subcategory_id = nil if post_params[:subcategory_id].nil?

      if @post.update(post_params)
        redirect(@post, params)
      else
        render :edit
      end
    end

    def clone
      @post = Post.clone_record params[:post_id]

      if @post.save
        redirect_to posts_path
      else
        render :new
      end
    end

    def subcategories_of_cagegory
      @category = Category.find(params[:category_id])
      @subcategories = @category.subcategories
      respond_to do |format|
        format.js {}
      end
    end

    # DELETE /posts/1
    def destroy
      @post.destroy
      redirect_to posts_url, notice: actions_messages(@post)
    end

    def destroy_multiple
      Post.destroy redefine_ids(params[:multiple_ids])
      redirect_to(
        posts_path(page: @current_page, search: @query),
        notice: actions_messages(Post.new)
      )
    end

    private

    # Get submit key to redirect, only [:create, :update]
    def redirect(object, commit)
      if commit.key?('_save')
        redirect_to(object, notice: actions_messages(object))
      elsif commit.key?('_add_other')
        redirect_to(
          new_post_path,
          notice: actions_messages(object)
        )
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    def set_categories
      @categories = Category.order(:name)
    end

    # Only allow a trusted parameter "white list" through.
    def post_params
      params.require(:post).permit(
        :title, :body, :user_id, :category_id,
        :subcategory_id, :image, :public, :comments_open,
        :shared_enabled, :permalink, :tag_list
      )
    end

    def show_history
      get_history(Post)
    end
  end
end
