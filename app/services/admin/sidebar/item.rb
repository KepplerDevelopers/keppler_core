# frozen_string_literal: true

module Admin
  module Sidebar
    class Item
      attr_accessor :name, :url_path, :icon, :model, :submenu

      def initialize(args)
        @user = args[:user]
        @name = args[:name]
        @url_path = args[:url_path]
        @icon = args[:icon]
        @model = args[:model].present? ? args[:model].constantize : nil
        @submenu = args[:submenu]
      end

      def submenu?
        submenu.present?
      end

      def submenu_item?
        submenu_item
      end
    end
  end
end
