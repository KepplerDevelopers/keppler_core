module App
  # AppController -> Controller out the back-office
  class AppController < ApplicationController
    layout 'layouts/app/application'
    before_filter :set_metas

    def index
    end

    private

    def set_metas
      @meta = MetaTag.get_by_url(request.url)
      @google_adword = GoogleAdword.get_by_url(request.url)
    end
  end
end
