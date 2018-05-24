module App
  # FrontsController
  class FrontController < AppController
    layout 'layouts/templates/application'

    def index
    end

    def post
      @post = Post.first
    end

  end
end
