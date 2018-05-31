# frozen_string_literal: true

# Creates a much prettier version of the file input field
class KepplerBooleanInput < SimpleForm::Inputs::Base
  def input(_wrapper_options)
    initializers
    template.content_tag(:label, '', class: 'keppler-switch') do
      template.tag(
        :input,
        class: ('active' if try_boolean),
        name: @input_name,
        type: 'checkbox',
        checked: true,
        value: try_boolean.to_s
      ) +
        template.content_tag(:span, '', class: 'slider round') +
        template.content_tag(
          :label,
          try_boolean.to_s,
          class: "inline-label #{'active' if try_boolean}"
        )
    end
  end

  def label_switch
    template.content_tag(:label, '', class: 'keppler-switch')
  end

  def input_switch
    template.tag(
      :input,
      class: ('active' if try_boolean),
      id: "switch-#{object}-#{attribute_name}",
      type: 'checkbox',
      checked: try_boolean.to_s
    )
  end

  def span_slider_round
    template.content_tag(:span, '', class: 'slider round')
  end

  # def script
  #   template.content_tag(
  #     :script,
  #       `$('.keppler-switch').click(function(event) {
  #         event.preventDefault()
  #         var input = $(this).find('input')
  #         var label = $(this).find('.inline-label')
  #         input
  #           .toggleClass('active')
  #           .val(input.hasClass('active'))
  #         label
  #           .toggleClass('active')
  #           .text(label.hasClass('active'))
  #       })`
  #   )
  # end

  private

  def try_boolean
    object.try(attribute_name) ? true : false
  end

  protected

  def initializers
    @model = lookup_model_names.join('_')
    @attribute = reflection_or_attribute_name
    @input_id = "#{@model}_#{@attribute}"
    @input_name = "#{@model}[#{@attribute}]"
  end
end
