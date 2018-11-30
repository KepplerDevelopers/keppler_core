# frozen_string_literal: true

# HtmlFile Module
module KepplerFrontend
  module Concerns
    module ScssFile
      extend ActiveSupport::Concern

      def scss_code
        File.read("#{url_front}/app/assets/stylesheets/keppler_frontend/app/views/#{name}.scss")
      end
      
      private

      def url_front
        "#{Rails.root}/rockets/keppler_frontend"
      end
    end
  end
end
