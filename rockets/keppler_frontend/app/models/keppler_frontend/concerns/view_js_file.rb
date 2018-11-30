# frozen_string_literal: true

# HtmlFile Module
module KepplerFrontend
  module Concerns
    module ViewJsFile
      extend ActiveSupport::Concern

      def view_js_code
        html=File.readlines("#{url_front}/app/views/keppler_frontend/app/frontend/#{name}.js.erb")
        html.join
      end
      
      private

      def url_front
        "#{Rails.root}/rockets/keppler_frontend"
      end
    end
  end
end
