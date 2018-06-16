# frozen_string_literal: true

# Creates a much prettier version of the file input field
class KepplerFileInput < SimpleForm::Inputs::Base
  def input(_wrapper_options)
    @builder.file_field(
      attribute_name,
      class: 'file',
      type: 'file',
      multiple: input_options[:multiple] || false,
      'data-preview-file-type' => 'text',
      value: (object.try(attribute_name) if attr_blank?)
    ) + script
  end

  def script
    initializers
    template.content_tag(:script, 'text/javascript') do
      "$('##{@input_id}').fileinput({
        language: '#{I18n.locale}',
        showUpload: false,
        showCancel: false,
        previewZoomButtonIcons: {
          prev: '<i class=\"glyphicon glyphicon-triangle-left\"></i>',
          next: '<i class=\"glyphicon glyphicon-triangle-right\"></i>',
          toggleheader: '<i class=\"glyphicon glyphicon-resize-vertical\"></i>',
          fullscreen: '<i class=\"glyphicon glyphicon-fullscreen\"></i>',
          borderless: '<i class=\"glyphicon glyphicon-resize-full\"></i>',
          close: '<i class=\"glyphicon glyphicon-remove\"></i>'
        },
        previewZoomButtonClasses: {
          prev: 'btn btn-navigate',
          next: 'btn btn-navigate',
          toggleheader: 'btn btn-default btn-header-toggle',
          fullscreen: 'btn btn-default',
          borderless: 'btn btn-default',
          close: 'btn btn-default'
        },
        allowedPreviewTypes: #{input_options[:only] || %w[image video audio pdf]},
        allowedPreviewMimeTypes: null,
        allowedFileTypes: #{input_options[:only] || []},
        allowedFileExtensions: null,
        defaultPreviewContent: null,
        previewFileIcon: '<i class=\"glyphicon glyphicon-file\"></i>',
        buttonLabelClass: 'hidden-xs',
        browseIcon: '<i class=\"glyphicon glyphicon-folder-open\"></i>&nbsp;',
        browseClass: 'btn btn-primary',
        removeIcon: '<i class=\"glyphicon glyphicon-trash\"></i>',
        removeClass: 'btn btn-default',
        cancelIcon: '<i class=\"glyphicon glyphicon-ban-circle\"></i>',
        cancelClass: 'btn btn-default',
        uploadIcon: '<i class=\"glyphicon glyphicon-upload\"></i>',
        uploadClass: 'btn btn-default',
        minImageWidth: 300,
        minImageHeight: 300,
        maxImageWidth: 5000,
        maxImageHeight: 5000,
        maxFileSize: 0,
        maxFilePreviewSize: 25600, // 25 MB
        minFileCount: 0,
        maxFileCount: 0
      })".html_safe
    end
  end

  private

  def include_attribute?(param)
    @attachments.map{ |x| x.include?('uno') }.include?(true)
  end

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
