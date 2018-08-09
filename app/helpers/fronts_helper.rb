# frozen_string_literal: true

# FrontsHelper
module FrontsHelper
  def set_head
    render 'layouts/keppler_frontend/app/layouts/head'
  end

  def basic_info
    Setting.first
  end

  def set_social
    Setting.first.social_account
  end
end
