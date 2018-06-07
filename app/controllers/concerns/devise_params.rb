# frozen_string_literal: true

# DeviseParams
module DeviseParams
  extend ActiveSupport::Concern

  private

  def configure_permitted_parameters
    RUBY_VERSION < '2.2.0' ? devise_old : devise_new
  end

  def devise_new
    devise_parameter_sanitizer.permit(:sign_up,
                                      keys: %I[name email
                                               password
                                               password_confirmation])
    devise_parameter_sanitizer.permit(:account_update,
                                      keys: %I[name email
                                               password
                                               password_confirmation])
  end

  def devise_old
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:name, :email, :password, :password_confirmation)
    end
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:name, :email, :password, :password_confirmation,
               :current_password)
    end
  end
end
