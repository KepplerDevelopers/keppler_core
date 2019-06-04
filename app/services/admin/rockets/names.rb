# frozen_string_literal: true

module Admin
  module Rockets
    # Git Handler
    class Names
      def list
        Dir["#{Rails.root}/rockets/*"].map do |dir|
          rocket_name = dir.split('/').last
          dir_size = 0
          Dir.glob("#{dir}/**/**").map do |file|
            dir_size += File.size(file)
          end
          "#{rocket_name} (#{file.size_format(dir_size)})"
        end
      rescue StandardError
        false
      end

      def name_format(name)
        name
          .remove(':', ';', '\'', '"')
          .downcase
          .parameterize
          .dasherize
          .remove('keppler-')
          .underscore
      end

      private

      def file
        Admin::Utils::File.new
      end
    end
  end
end
