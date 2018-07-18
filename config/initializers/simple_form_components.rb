# frozen_string_literal: true

module SimpleForm
  module Components
    # Helper para activar los iconos en los componentes bootstrap
    module Icons
      def icon(_wrapper_options = nil)
        return icon_tag unless options[:icon].nil?
      end

      def icon_tag
        template.content_tag(:i, '', class: options[:icon])
      end
    end

    # Helper para activar los tooltips en los componentes bootstrap
    module Tooltips
      def tooltip(_wrapper_options = nil)
        return if tooltip_text.nil?
        input_html_options[:rel] ||= 'tooltip'
        input_html_options['data-toggle'] ||= 'tooltip'
        input_html_options['data-placement'] ||= tooltip_position
        input_html_options['data-trigger'] ||= 'focus'
        input_html_options['data-original-title'] ||= tooltip_text
        nil
      end

      def tooltip_text
        tooltip = options[:tooltip]
        tooltip if tooltip.is_a?(String)
        tooltip[1] if tooltip.is_a?(Array)
      end

      def tooltip_position
        tooltip = options[:tooltip]
        tooltip.is_a?(Array) ? tooltip[0] : 'right'
      end
    end

    # Helper para activar los typeahead en los componentes bootstrap
    module Typeahead
      def typeahead(_wrapper_options = nil)
        return if typeahead_source.empty?
        input_html_options['data-provide'] ||= 'typeahead'
        input_html_options['data-items'] ||= 5
        input_html_options['data-source'] ||= typeahead_source.inspect.to_s
        nil
      end

      def typeahead_source
        Array(options[:typeahead])
      end
    end
  end
end

SimpleForm::Inputs::Base.send(:include, SimpleForm::Components::Icons)

SimpleForm::Inputs::Base.send(:include, SimpleForm::Components::Tooltips)

SimpleForm::Inputs::Base.send(:include, SimpleForm::Components::Typeahead)
