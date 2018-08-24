# frozen_string_literal: true

# HtmlFile Module
module KepplerLanguages
  module Concerns
    module YmlFile
      extend ActiveSupport::Concern

      def create_yml
        file = File.open("#{url}/config/locales/kl.#{name}.yml", "w")
        file.puts("#{name}: \n");
        file.puts("  keppler_languages: \n");
        file.close
        true
      end

      def delete_yml
        file = "#{url}/config/locales/kl.#{name}.yml"
        File.delete(file) if File.exist?(file)
        true
      end

      def update_yml(yml)
        file = "#{url}/config/locales/kl.#{name}.yml"
        obj = Language.find(id)
        old_name = "#{url}/config/locales/kl.#{obj.name}.yml"
        new_name = "#{url}/config/locales/kl.#{yml[:name]}.yml"

        yml_file = File.readlines(file)

        head_idx = 0

        yml_file.each do |i|
          head_idx = yml_file.find_index(i) if i.include?("#{obj.name}:")
        end

        yml_file[head_idx] = "#{yml[:name]}:\n"
        yml_file = yml_file.join('')
        File.write(file, yml_file)
        File.rename(old_name, new_name)
        true
      end

      private

      def url
        "#{Rails.root}/rockets/keppler_languages"
      end
    end
  end
end
