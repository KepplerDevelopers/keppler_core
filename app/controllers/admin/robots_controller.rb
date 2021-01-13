# frozen_string_literal: true

module Admin
  # Robots
  class RobotsController < AdminController
    before_action :authorization

    def index
      @robots = scope.new
    end

    def update
      scope.save_robots(params[:txt]) if params[:txt]
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
