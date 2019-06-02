# frozen_string_literal: true

module Admin
  # Sitemap
  class SitemapsController < AdminController
    before_action :authorization

    def index
      @sitemap = scope.new
    end

    def update
      scope.save_sitemap(params[:ruby]) if params[:ruby]
    end

    def scope
      Seo
    end

    private

    def authorization
      authorize scope
    end

    def show_history
      get_history(scope)
    end
  end
end
