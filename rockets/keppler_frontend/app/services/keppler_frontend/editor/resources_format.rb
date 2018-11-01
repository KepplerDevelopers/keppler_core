# frozen_string_literal: true

module KepplerFrontend
  module Editor
    # Assets
    class ResourcesFormat
      def initialize(input)
        @file = input
        @name = input.split('.').first
        @extend = File.extname(input)
        @folder = folder_name(@file)
        @size = File.size("#{url_core(@folder)}/#{@file}")
        @cover = url.front_assets(input) 
        @cover_url = "#{url_core('html')}/#{input}"
      end

      def output            
        {
          id: SecureRandom.uuid,
          name: @file,
          url: "#{url_core(@folder)}/#{@file}",
          search: @name,
          path: url.front_assets(@file),
          folder: @folder,
          size: utils.size(@size),
          format: @extend.split('.').last,
          html: @folder.eql?('html') ? code_custom : '',
          cover: File.file?(@cover_url) ? @cover : nil,
          cover_url: File.file?(@cover_url) ? @cover_url : ''
        }
      end

      private

      def folder_name(file)
        file_format = KepplerFrontend::Utils::FileFormat.new
        file_format.folder(file)
      end

      def url
        KepplerFrontend::Urls::Assets.new
      end

      def utils
        KepplerFrontend::Utils::FileFormat.new
      end

      def url_core(folder)
        url.core_assets(folder, 'app')
      end

      def code_custom
        html = File.readlines("#{url_core('html')}/#{@file}}")
        html.join
      end
    end
  end
end
