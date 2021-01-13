# frozen_string_literal: true

module Admin
  module Sidebar
    MENU_PATH = "#{Rails.root}/config/menu.yml"
    ROCKET_PATHS = Dir[File.join("#{Rails.root}/rockets", '*')]
    # Config builder service
    class ConfigBuilder
      def config
        @config ||= build
      end

      private

      def build
        @mapping = deep_symbolize_keys(MENU_PATH)

        ROCKET_PATHS.each do |path|
          path_menu = "#{path}/config/menu.yml"

          next unless File.file?(path_menu)

          rocket_menu = deep_symbolize_keys(path_menu)

          @mapping = @mapping.merge(rocket_menu)
        end

        sort_menu(@mapping)
      end

      def deep_symbolize_keys(path)
        YAML.load_file(path).values.each(&:deep_symbolize_keys!).first
      end

      def sort_menu(config)
        config.sort_by { |_, v| v&.dig(:position) || 0 }
      end
    end
  end
end
