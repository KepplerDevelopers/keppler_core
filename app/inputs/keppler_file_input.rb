# frozen_string_literal: true

# Creates a much prettier version of the file input field
class KepplerFileInput < SimpleForm::Inputs::Base
  def input(_wrapper_options)
    @builder.file_field(
      attribute_name,
      class: 'keppler-file',
      multiple: input_options[:multiple] || false,
      'data-preview-file-type' => 'any',
      value: (object.try(attribute_name) if attr_blank?)
    ) + script
  end

  def script
    initializers
    template.content_tag(:script, type: 'text/javascript') do
      "$('##{@input_id}').fileinput({
        language: '#{I18n.locale}',
        showUpload: false,
        showCancel: false,
        #{init_preview}
        // init_preview_details
        #{preview_zoom_button_icons}
        #{preview_zoom_button_classes}
        #{preview_details}
        #{icons}
        #{dimensions}
      })".html_safe
    end
  end

  private

  def init_preview
    return if !object.id || @obj_attr.file.nil?
    initializers
    if @obj_attr.is_a?(Array)
      @obj_attr.each { |img| preview_tag(img) }
    else
      preview_tag(@obj_attr)
    end
    ('initialPreview: ' + @previews.to_s).html_safe + ','
  end

  def preview_tag(preview)
    tag =
      "<img class='kv-preview-data file-preview-image' src='/uploads
      #{preview.file.file.split('/uploads').last}'>"
    @previews.push(tag)
  end

  # def init_preview_details
  #   "layoutTemplates: {
  #     actionDelete: '',
  #     actionDrag: '',
  #   }".html_safe + ','
  # end

  def preview_zoom_button_icons
    "previewZoomButtonIcons: {
      prev: '<i class=\"glyphicon glyphicon-triangle-left\"></i>',
      next: '<i class=\"glyphicon glyphicon-triangle-right\"></i>',
      toggleheader: '<i class=\"glyphicon glyphicon-resize-vertical\"></i>',
      fullscreen: '<i class=\"glyphicon glyphicon-fullscreen\"></i>',
      borderless: '<i class=\"glyphicon glyphicon-resize-full\"></i>',
      close: '<i class=\"glyphicon glyphicon-remove\"></i>'
    }".html_safe + ','
  end

  def preview_zoom_button_classes
    "previewZoomButtonClasses: {
      prev: 'btn btn-navigate',
      next: 'btn btn-navigate',
      toggleheader: 'btn btn-default btn-header-toggle',
      fullscreen: 'btn btn-default',
      borderless: 'btn btn-default',
      close: 'btn btn-default'
    }".html_safe + ','
  end

  def preview_details
    "allowedPreviewMimeTypes: null,
    allowedFileTypes: #{input_options[:type] || []},
    allowedFileExtensions: #{input_options[:formats] || []},
    defaultPreviewContent: null".html_safe + ','
  end

  def icons
    "previewFileIcon: '<i class=\"glyphicon glyphicon-file\"></i>',
    buttonLabelClass: 'hidden-xs',
    browseIcon: '<i class=\"icon-folder-alt\"></i>&nbsp;',
    browseClass: 'btn btn-primary',
    removeIcon: '<i class=\"icon-trash\"></i>',
    removeClass: 'btn btn-default',
    cancelIcon: '<i class=\"glyphicon glyphicon-ban-circle\"></i>',
    cancelClass: 'btn btn-default',
    uploadIcon: '<i class=\"glyphicon glyphicon-upload\"></i>',
    uploadClass: 'btn btn-default'".html_safe + ','
  end

  def dimensions
    "minImageWidth: 300,
    minImageHeight: 300,
    maxImageWidth: 5000,
    maxImageHeight: 5000,
    maxFileSize: #{input_options[:max_size] || 225},
    maxFilePreviewSize: #{input_options[:max_preview_size] || 25_600}, // 25 MB
    minFileCount: 0,
    maxFileCount: 0".html_safe + ','
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
    @obj_attr = object.try(attribute_name)
    @previews = []
  end
end
