# frozen_string_literal: true

module KepplerFrontend
  module Editor
    # CodeHandler
    class FileFormat
      def initialize; end

      def validate(file)
        content_type = File.extname(file)
        result = false
        utils_files.formats.each do |_key, value|
          result = true if value.include?(content_type)
        end
        result
      end

      private

      def utils_files
        KepplerFrontend::Utils::FileFormat.new
      end

      def assets
        KepplerFrontend::Urls::Assets.new
      end
    end
  end
end
