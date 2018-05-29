# frozen_string_literal: true

# Creates a much prettier version of the file input field
class KepplerBooleanInput < SimpleForm::Inputs::Base
  def initializers
    @model = lookup_model_names.join('_')
    @attribute = reflection_or_attribute_name
    @idf = "#{@model}_#{@attribute}"
    @namef = "#{@model}[#{@attribute}]"
  end

  def input
    label_switch do
      input_switch +
        span_slider_round
    end
  end

  def label_switch
    template.tag(:label, class: 'switch')
  end

  def input_switch
    template.tag(
      :input,
      class: ('active' if object.try(attribute_name)),
      id: "switch-#{object}-#{attribute_name}",
      type: 'checkbox',
      checked: object.try(attribute_name) ? true : false
    )
  end

  def span_slider_round
    template.content_tag(
      :span,
      class: 'slider round'
    )
  end
end
