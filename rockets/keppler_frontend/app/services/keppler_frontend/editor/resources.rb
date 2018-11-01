# frozen_string_literal: true

module KepplerFrontend
  module Editor
    # Assets
    class Resources
      def initialize; end

      def list
        files_result = []
        utils.folders.each do |folder|
          result = only_files_validated(folder)
          files_result = files_result + result
        end
        files_result = files_result.select { |f| f unless f.nil? }
        sort(files_result)
      end

      def custom_list(custom)
        custom = 'app/bootstrap' if custom.eql?('bootstrap')
        files = only_files_custom_validated(custom)
        files = files.map do |file|
          render(file, 'views').output
        end
        sort(files)
      end

      private

      def sort(files)
        files.sort_by { |k| k[:name] }
      end

      def only_files_validated(folder)
        result = Dir.entries(url.core_assets(folder, 'app'))
        result = result.select { |f| f if files.validate(f) }
        result.map do |f|
          render(f, 'app').output unless files.html_cover?(f)
        end
      end

      def only_files_custom_validated(custom)
        result = Dir.entries(url.core_assets('html', custom))
        result.select { |f| f if files.validate(f) && utils.folder(f).eql?('html') }
      end

      def url
        KepplerFrontend::Urls::Assets.new
      end

      def files
        KepplerFrontend::Editor::FileFormat.new
      end

      def utils
        KepplerFrontend::Utils::FileFormat.new
      end

      def render(result, container)
        KepplerFrontend::Editor::ResourcesFormat.new(result, container)
      end      
    end
  end
end
