class ErrorsController < ApplicationController
	layout "errors/application"
  def not_authorized
  	respond_to do |format|
	    format.html { render template: 'errors/not_authorized', status: 403 }
	    format.all  { render nothing: true, status: 403 }
	  end
  end

  def not_found
  	respond_to do |format|
	    format.html { render template: 'errors/not_found', status: 404 }
	    format.all  { render nothing: true, status: 404 }
	  end
  end

  def unprocessable
  	respond_to do |format|
	    format.html { render template: 'errors/unprocessable', status: 422 }
	    format.all  { render nothing: true, status: 422 }
	  end
  end

  def internal_server_error
  	respond_to do |format|
	    format.html { render template: 'errors/internal_server_error', status: 500 }
	    format.all  { render nothing: true, status: 500 }
	  end
  end
end
