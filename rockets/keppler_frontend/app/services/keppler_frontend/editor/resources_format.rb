# frozen_string_literal: true

module KepplerFrontend
  module Editor
    # Assets
    class ResourcesFormat
      def initialize(input, container)
        @file = input
        @name = input.split('.').first
        @extend = File.extname(input)
        @folder = utils.folder(@file)
        @size = File.size("#{url_core(@folder, container)}/#{@file}")
        @cover = "/assets/keppler_frontend/views/#{@name}.png"
        @cover_url = "#{url_core('html', container)}/#{@name}.png"
        @container = container
      end

      def output
        file_object.merge(html_attr)
      end

      private

      def url
        KepplerFrontend::Urls::Assets.new
      end

      def utils
        KepplerFrontend::Utils::FileFormat.new
      end

      def url_core(folder, container)
        url.core_assets(folder, container)
      end

      def code_custom
        html = File.readlines("#{url_core('html', @container)}/#{@file}")
        html.join
      end

      def file_object
        {
          id: SecureRandom.uuid,
          name: @file,
          url: "#{url_core(@folder, @container)}/#{@file}",
          search: @name,
          path: url.views_assets(@file),
          folder: @folder,
          size: utils.size(@size),
          format: @extend.split('.').last
        }
      end

      def html_attr
        {
          html: @folder.eql?('html') ? code_custom : '',
          cover: File.file?(@cover_url) ? @cover : nil,
          cover_url: File.file?(@cover_url) ? @cover_url : ''
        }
      end
    end
  end
end
