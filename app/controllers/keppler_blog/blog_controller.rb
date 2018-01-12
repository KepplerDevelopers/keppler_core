# Generado con Keppler.
require_dependency 'keppler_blog/application_controller'

module KepplerBlog
  class BlogController < App::AppController
    layout 'app/layouts/application'
    before_action :set_data_widgets, only: [:index, :show, :filter, :filter_subcategory]

    def index
      #@q = Post.ransack(params[:q])
      posts = @q.result(distinct: true).where(public: true)
      @posts = posts.page(@current_page).per(KepplerBlog.posts_per_page)
      @total = posts.size

      if !@posts.first_page? && @posts.size.zero?
        redirect_to(
          posts_path(page: @current_page.to_i.pred, search: @query)
        )
      end
    end

    def show
      @post =  Post.find_by_permalink(params[:permalink])
    end

    def filter
      @posts = Post.send("filter_by_#{params[:type]}", params[:permalink]).page(@current_page).per(10)
      render action: 'index'
    end

    def filter_subcategory
      @posts = Post.filter_by_subcategory(params[:category], params[:subcategory]).page(@current_page).per(10)
      render action: 'index'
    end

    private

    def set_data_widgets
      @posts_recents = Post.where(public: true).order("created_at DESC").first(6)
      @categories = Category.all.order(:name)
      @q = Post.ransack(params[:q])
    end
  end
end
