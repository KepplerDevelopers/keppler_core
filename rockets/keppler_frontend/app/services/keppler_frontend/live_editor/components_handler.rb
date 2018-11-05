# frozen_string_literal: true

module KepplerFrontend
  module LiveEditor
    # CssHandler
    class ComponentsHandler
      def initialize; end

      def output
        list_components = []
        components = Dir["#{core_app}/**/*.html"]
        components.each do |component|
          lines = File.readlines(component)
          list_components << [script(component), content(lines)]
        end
        list_components
      end

      private

      def core_app
        urls = KepplerFrontend::Urls::Assets.new
        urls.core_assets('html', 'app')
      end

      def script(component)
        lines = File.readlines(component)
        find = KepplerFrontend::Utils::CodeSearch.new(lines)
        idx = find.search_section('<script>', '</script>')
        lines = lines[idx[0] + 1..idx[1] - 1].join('').delete("\n")
        "[#{lines}]"
      end

      def content(lines)
        find = KepplerFrontend::Utils::CodeSearch.new(lines)
        idx = find.search_section('<keppler-component>', '</keppler-component>')
        lines[idx[0] + 1..idx[1] - 1].join('')
      end
    end
  end
end
