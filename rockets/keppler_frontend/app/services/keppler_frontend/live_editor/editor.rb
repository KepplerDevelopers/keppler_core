# frozen_string_literal: true

module KepplerFrontend
  module LiveEditor
    # Activate
    class Editor
      def initialize(data)
        @data = data
      end

      def live_editor_render
        {
          view_id: @data[:view_id],
          view_name: @data[:view_name],
          css_style: css.output,
          images_assets: images.output,
          components: components.output
        }
      end

      private

      def css
        KepplerFrontend::LiveEditor::CssHandler.new(@data[:view_name])
      end

      def images
        KepplerFrontend::LiveEditor::ImagesHandler.new
      end

      def components
        KepplerFrontend::LiveEditor::ComponentsHandler.new
      end
    end
  end
end
