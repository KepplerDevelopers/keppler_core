class AdminController < ApplicationController
	before_filter :authenticate_user!
	layout 'admin/application'

	def index
		redirect_to dashboard_admin_index_path
	end

  def dashboard
  end
end
