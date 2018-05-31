# frozen_string_literal: true

# Creates a much prettier version of the file input field
class KepplerFileInput < SimpleForm::Inputs::Base
  def input(_wrapper_options)
    template.content_tag(:div, class: 'upload_image') do
      # input_label +
      template.content_tag(
        :div,
        class: "#{'files-absolute' unless attr_blank?} files form-group trigger"
      ) do
        # icon_file +
        photo_uploader
      end +
        image_to_upload
    end
  end

  def input_label
    initializers
    template.content_tag(
      :label,
      reflection_or_attribute_name.to_s.humanize,
      class: 'file optional',
      for: @input_id
    )
  end

  def icon_file
    template.content_tag(:div, class: 'icon-file') do
      template.content_tag(:i, '', class: 'glyphicon glyphicon-picture')
    end
  end

  def image_to_upload
    template.content_tag(:center, class: 'image-show') do
      template.tag(
        :img,
        class: "#{'hidden' if attr_blank?} image_to_upload",
        src: (object.try(attribute_name) || '')
      )
    end
  end

  def photo_uploader
    initializers
    @builder.file_field(
      attribute_name,
      class: 'photo_upload',
      type: 'file',
      id: @input_id,
      name: @input_name
    )
  end

  private

  def attr_blank?
    object.try(attribute_name).blank?
  end

  protected

  def initializers
    @input_id = "#{@model}_#{@attribute}"
    @input_name = "#{@model}[#{@attribute}]"
  end
end
