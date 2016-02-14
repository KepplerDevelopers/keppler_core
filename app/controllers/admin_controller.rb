# AdminController -> backoffice this appication keppler
class AdminController < ApplicationController
  before_filter :authenticate_user!
  layout 'admin/application'

  def index
    redirect_to '/admin/dashboard'
  end
end
