# frozen_string_literal: true

# HtmlFile Module
module KepplerLanguages
  module Concerns
    module YmlFile
      extend ActiveSupport::Concern

      def create_yml
        file = File.open("#{url}/config/locales/#{name}.yml", "w")
        file.puts("keppler_languages: \n");
        file.close
        true
      end

      def delete_yml
        file = "#{url}/config/locales/#{name}.yml"
        File.delete(file) if File.exist?(file)
        true
      end

      private

      def url
        "#{Rails.root}/rockets/keppler_languages"
      end

    end
  end
end
