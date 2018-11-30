# frozen_string_literal: true

# HtmlFile Module
module KepplerFrontend
  module Concerns
    module JsFile
      extend ActiveSupport::Concern

      def js_code
        File.read("#{url_front}/app/assets/javascripts/keppler_frontend/app/views/#{name}.js")
      end

      private

      def url_front
        "#{Rails.root}/rockets/keppler_frontend"
      end
    end
  end
end
