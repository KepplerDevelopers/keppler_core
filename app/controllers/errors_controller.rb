# ErrorsController -> Controller to redirect error pages
class ErrorsController < ApplicationController
  layout 'errors/application'
  def not_authorized
    respond_error 'errors/not_authorized', 403
  end

  def not_found
    respond_error 'errors/not_found', 404
  end

  def unprocessable
    respond_error 'errors/unprocessable', 422
  end

  def internal_server_error
    respond_error 'errors/internal_server_error', 500
  end

  private

  def respond_error(template, status)
    respond_to do |format|
      format.html { render template: template, status: status }
      format.all { render nothing: true, status: status }
    end
  end
end
