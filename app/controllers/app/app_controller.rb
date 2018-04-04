module App
  # AppController -> Controller out the back-office
  class AppController < ::ApplicationController
    layout 'app/layouts/application'
    before_filter :set_metas
    before_filter :set_analytics

    def set_metas
      @setting = Setting.first
      @title = @setting.name
      @description = @setting.description
      @favicon = @setting.favicon
      @meta = MetaTag.get_by_url(request.url)
      @social = SocialAccount.last
    end

    private

    def set_analytics
      @scripts = Script.all
    end
  end
end
