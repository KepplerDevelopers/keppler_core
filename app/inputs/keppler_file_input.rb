# frozen_string_literal: true

# Creates a much prettier version of the file input field
class KepplerFileInput < SimpleForm::Inputs::Base
  def initializers
    @model = lookup_model_names.join('_')
    @attribute = reflection_or_attribute_name
    @idf = "#{@model}_#{@attribute}"
    @namef = "#{@model}[#{@attribute}]"
  end

  def input(wrapper_options)
    template.content_tag(:div, class: 'upload_image') do
      # input_label +
      template.content_tag(:div, class: "#{'files-absolute' unless object.try(attribute_name).blank?} files form-group trigger") do
        # icon_file +
        photo_uploader
      end +
      image_to_upload
    end
  end

  def input_label
    template.content_tag(
      :label,
      reflection_or_attribute_name.to_s.humanize,
      class: 'file optional',
      for: "#{lookup_model_names.join('_')}_#{reflection_or_attribute_name}"
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
        class: "#{'hidden' if object.try(attribute_name).blank?} image_to_upload",
        src: (object.try(attribute_name) || '')
      )
    end
  end

  def photo_uploader
    @builder.file_field(
      attribute_name,
      class: 'photo_upload',
      type: 'file',
      id: "#{lookup_model_names.join('_')}_#{reflection_or_attribute_name}",
      name: "#{lookup_model_names.join('_')}[#{reflection_or_attribute_name}]"
    )
  end
end
