# frozen_string_literal: true

module Admin
  # SeosController
  class SeosController < AdminController
    before_action :authorization

    def sitemap
      @sitemap = Seo.new
    end

    def robots
      @robots = Seo.new
    end

    def editor_save
      Seo.save_sitemap(params[:ruby]) if params[:ruby]
      Seo.save_robots(params[:txt]) if params[:txt]
    end

    private

    def authorization
      authorize Seo
    end

    def show_history
      get_history(Seo)
    end
  end
end
