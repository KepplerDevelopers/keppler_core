# frozen_string_literal: true

# Creates a much prettier version of the file input field
class KepplerBooleanInput < SimpleForm::Inputs::Base
  def input(_wrapper_options)
    initializers
    template.content_tag(:label, '', class: 'keppler-switch') do
      input_switch + span_slider_round + label_switch
    end
  end

  def label_switch
    template.content_tag(
      :label,
      try_boolean.to_s,
      class: "inline-label #{'active' if try_boolean}"
    )
  end

  def input_switch
    template.tag(
      :input,
      class: ('active' if try_boolean),
      name: @input_name,
      type: 'checkbox',
      checked: true,
      value: try_boolean.to_s
    )
  end

  def span_slider_round
    template.content_tag(:span, '', class: 'slider round')
  end

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
