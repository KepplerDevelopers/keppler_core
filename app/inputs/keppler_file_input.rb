# frozen_string_literal: true

# Creates a much prettier version of the file input field
class KepplerFileInput < SimpleForm::Inputs::Base
  def input(_wrapper_options)
    @builder.file_field(
      attribute_name,
      class: 'file',
      multiple: input_options[:multiple] || false,
      'data-preview-file-type' => 'any',
      value: (object.try(attribute_name) if attr_blank?)
    )
  end

  private

  def attr_blank?
    object.try(attribute_name).blank?
  end

  protected

  def initializers
    @model = lookup_model_names.join('_')
    @attribute = reflection_or_attribute_name
    @input_id = "#{@model}_#{@attribute}"
    @input_name = "#{@model}[#{@attribute}]"
    images = object.try(attribute_name)
    @images = images.is_a?(Array) ? images : []
  end
end
