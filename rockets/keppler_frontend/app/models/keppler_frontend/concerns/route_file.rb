# frozen_string_literal: true

# HtmlFile Module
module KepplerFrontend
  module Concerns
    module RouteFile
      extend ActiveSupport::Concern

      def add_route
        file = "#{url_front}/config/routes.rb"
        index_html = File.readlines(file)
        head_idx = 0
        index_html.each do |i|
          head_idx = index_html.find_index(i) if i.include?('KepplerFrontend::Engine.routes.draw do')
        end
        if active.eql?(false)
          index_html.insert(head_idx.to_i + 1, "#  #{method.downcase!} '#{url}', to: 'app/frontend##{name}', as: :#{name}\n")
        else
          index_html.insert(head_idx.to_i + 1, "  #{method.downcase!} '#{url}', to: 'app/frontend##{name}', as: :#{name}\n")
        end
        index_html = index_html.join('')
        File.write(file, index_html)
        true
      end

      def delete_route
        file = "#{url_front}/config/routes.rb"
        index_html = File.readlines(file)
        head_idx = 0
        index_html.each do |idx|
          if active.eql?(false)
            head_idx = index_html.find_index(idx) if idx.include?("#  #{method.downcase} '#{url}', to: 'app/frontend##{name}', as: :#{name}\n")
          else
            head_idx = index_html.find_index(idx) if idx.include?("  #{method.downcase} '#{url}', to: 'app/frontend##{name}', as: :#{name}\n")
          end
        end
        return if head_idx==0
        index_html.delete_at(head_idx.to_i)
        index_html = index_html.join('')
        File.write(file, index_html)
        true
      end

      private

      def url_front
        "#{Rails.root}/rockets/keppler_frontend"
      end
    end
  end
end
