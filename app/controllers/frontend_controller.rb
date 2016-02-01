class FrontendController < ApplicationController
	layout 'layouts/frontend/application'
	before_filter :set_settings
	
  def index
  end

  private

  def set_settings
    @setting = Setting.first
    @meta = MetaTag.get_by_url(request.url)
    @google_adword = GoogleAdword.get_by_url(request.url)
  end
end
