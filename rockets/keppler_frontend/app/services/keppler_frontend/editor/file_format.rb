# frozen_string_literal: true

module KepplerFrontend
  module Editor
    # CodeHandler
    class FileFormat
      def initialize; end

      def validate(file)
        content_type = File.extname(file)
        result = false
        utils_files.formats.each do |key, value|
          result = true if value.include?(content_type)
        end
        result
      end

      def html_cover?(file)
        files = []
        utils_files.folders.each do |folder|
          files = Dir.entries(assets.core_assets(folder, 'app'))
          folder_img = utils_files.folder(file)
          files = files.select { |f| f.eql?(file) && folder_img.eql?('images') }
          return true if !files.count.zero? && folder.eql?('html')
        end
        return false if files.count.zero?
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
