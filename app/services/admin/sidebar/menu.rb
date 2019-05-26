# frozen_string_literal: true

module Admin
  module Sidebar
    class Menu

      def initialize(user)
        @user = user
      end

      def items
        build_menu
      end

      private

      def build_menu
        config.map do |_, values|
          attrs = { user: @user }
          attrs.merge!(values.except(:submenu))
          submenu = values[:submenu]
          attrs.merge!(submenu: build_submenu(submenu)) if submenu.present?

          Item.new(attrs)
        end
      end

      def build_submenu(submenu)
        submenu.map do |item|
          attrs = { user: @user }
          Item.new(attrs.merge(item.values.first))
        end
      end

      def config
        ConfigBuilder.config
      end
    end
  end
end
