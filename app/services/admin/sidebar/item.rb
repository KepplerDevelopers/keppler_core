# frozen_string_literal: true

module Admin
  module Sidebar
    class Item
      attr_accessor :name, :url_path, :icon, :model, :submenu, :current

      def initialize(args)
        @user = args[:user]
        @name = args[:name]
        @url_path = args[:url_path]
        @icon = args[:icon]
        @model = args[:model].present? ? args[:model].constantize : nil
        @submenu = args[:submenu]
        @position = args[:position]
        @current = args[:current]
      end

      def submenu?
        submenu.present?
      end

      def submenu_item?
        submenu_item
      end

      def current?(controller_path)
        current.include?(controller_path)
      end
    end
  end
end
