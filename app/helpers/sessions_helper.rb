# frozen_string_literal: true

# SessionsHelper Backoffice
module SessionsHelper
  def keppler_new_session
    "/#{@appearance.admin_code}/sign_in"
  end

  def keppler_destroy_session
    "/#{@appearance.admin_code}/sign_out"
  end
end
