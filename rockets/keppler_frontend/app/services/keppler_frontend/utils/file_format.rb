# frozen_string_literal: true

module KepplerFrontend
  module Utils
    # CodeHandler
    class FileFormat
      def initialize; end

      def folders
        %w[audios fonts images videos html javascripts stylesheets]
      end

      def formats
        {
          audios: ['.mp3'],
          fonts: ['.eot', '.otf', '.ttf', '.woff', '.woff2'],
          images: ['.jpg', '.jpeg', '.png', '.svg', '.gif', '.tiff', '.bmp'],
          videos: ['.mp4', '.mpeg', '.webm', '.m4v'],
          html: ['.html'],
          javascripts: ['.js', '.coffee', '.json'],
          stylesheets: ['.css', '.scss', '.sass']
        }
      end

      def folder(file)
        content_type = File.extname(file)
        result = ''
        formats.each do |key, value|
          result = key.to_s if value.include?(content_type)
        end
        result
      end

      def size(size)
        units = %w[B Kb Mb Gb Tb Pb Eb]
        return '0.0 B' if size.zero?
        exp = (Math.log(size) / Math.log(1024)).to_i
        exp = 6 if exp > 6
        result = (size.to_f / 1024 * exp).round(1)
        format('%<result>s %<units>s', result: result, units: units[exp])
      end
    end
  end
end
