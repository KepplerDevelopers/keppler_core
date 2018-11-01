# frozen_string_literal: true

module KepplerFrontend
  module Editor
    # Assets
    class Resources
      def initialize; end

      def list
        files_result = []
        utils.folders.each do |folder|
          result = Dir.entries(assets.core_assets(folder, 'app'))
          result = result.select { |f| f if files.validate(f) }
          result = result.map do |f|
            render(f).output unless files.html_cover?(f)
          end
          files_result = files_result + result
        end
        files_result = files_result.select { |f| f unless f.nil? }
        files_result.sort_by { |k| k[:name] }
      end

      def custom_list(custom)
      end

      private

      def root
        KepplerFrontend::Urls::Roots.new
      end

      def assets
        KepplerFrontend::Urls::Assets.new
      end

      def files
        KepplerFrontend::Editor::FileFormat.new
      end

      def utils
        KepplerFrontend::Utils::FileFormat.new
      end

      def render(result)
        KepplerFrontend::Editor::ResourcesFormat.new(result)
      end      
    end
  end
end
