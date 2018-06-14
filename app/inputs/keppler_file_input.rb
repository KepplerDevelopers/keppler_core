# frozen_string_literal: true

# Creates a much prettier version of the file input field
class KepplerFileInput < SimpleForm::Inputs::Base
  def input(_wrapper_options)
    @builder.file_field(
      attribute_name,
      class: 'file',
      multiple: input_options[:multiple] || false,
      'data-preview-file-type' => 'any'
    ) + script
  end

  def script
    initializers
    template.content_tag(:script, type: 'text/javascript') do
      "$('##{@input_id}').fileinput({
        language: '#{I18n.locale}',
        showUpload: false,
        browseIcon: '<i class=icon-folder-alt></i>&nbsp;',
        removeIcon: '<i class=icon-trash></i>',
        previewFileIcon: '<i class=icon-doc></i>'
      });".html_safe
    end
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
  end
end
