module App
  # AppController -> Controller out the back-office
  class AppController < ::ApplicationController
    layout 'app/layouts/application'
    before_filter :set_metas

    def set_metas
      @setting = Setting.first
      @title = @setting.name
      @description = @setting.description
      @favicon = @setting.favicon
      @meta = MetaTag.get_by_url(request.url)
      @google_adword = GoogleAdword.get_by_url(request.url)
    end
  end
end
