class FrontendController < ApplicationController
	layout 'layouts/frontend/application'
	
  def index
  	@setting = Setting.first
  end
end
