# frozen_string_literal: true

# HtmlFile Module
module KepplerFrontend
  module Concerns
    module LayoutFile
      extend ActiveSupport::Concern

      def layout_code
        html=File.readlines("#{url_front}/app/views/layouts/keppler_frontend/app/layouts/application.html.erb")
        html.join
      end

      private

      def url_front
        "#{Rails.root}/rockets/keppler_frontend"
      end
    end
  end
end
