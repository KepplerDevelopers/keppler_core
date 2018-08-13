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

      def update_yml(yml)
        obj = Language.find(id)
        old_name = "#{url}/config/locales/#{obj.name}.yml"
        new_name = "#{url}/config/locales/#{yml[:name]}.yml"
        File.rename(old_name, new_name)
      end

      private

      def url
        "#{Rails.root}/rockets/keppler_languages"
      end

    end
  end
end
