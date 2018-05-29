# frozen_string_literal: true

# Creates a much prettier version of the file input field
class KepplerCheckboxesInput < SimpleForm::Inputs::Base
  def initializers
    @model = lookup_model_names.join('_')
    @attribute = reflection_or_attribute_name
    @idf = "#{@model}_#{@attribute}"
    @namef = "#{@model}[#{@attribute}]"
  end

  def input
    template.content_tag(:div, class: 'checkbox') do
      input_label do
        label_text +
          input_checkbox +
          span_cr do
            check_icon
          end
      end
    end
  end

  def input_label
    template.content_tag(
      :label,
      t("activerecord.attributes.#{attribute_name}").humanize,
      for: "#{lookup_model_names.join('_')}_#{reflection_or_attribute_name}"
    )
  end

  def label_text
    template.content_tag(
      :span,
      t("activerecord.attributes.#{attribute_name}").humanize,
      class: 'label-text'
    )
  end

  def input_checkbox
    @builder.check_boxes(
      attribute_name,
      type: 'checkbox',
      'checklist-model' => 'check'
    )
  end

  def span_cr
    template.content_tag(:span, class: 'cr')
  end

  def check_icon
    template.content_tag(:i, class: 'cr-icon glyphicon glyphicon-ok')
  end
end
