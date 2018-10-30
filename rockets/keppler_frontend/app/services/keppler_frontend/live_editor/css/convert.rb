# frozen_string_literal: true

require 'sass/css'

module KepplerFrontend
  module LiveEditor
    module Css
      # CssHandler
      class Convert
        def initialize(input)
          @input = input
        end

        def to_scss
          scss = Sass::CSS.new(@input).render(:scss)
          scss = scss.split("\n").select do |line|
            line unless line.include?('initial') || line.include?('undefined')
          end
          scss.join("\n")
        end

        def to_css
          Sass::Engine.for_file(@input, {}).render
        end
      end
    end
  end
end
