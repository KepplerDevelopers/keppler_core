# FileMaterialInput
class FileMaterialInput < SimpleForm::Inputs::Base
  def input(_wrapper_options = nil)
    template.content_tag(:div, file_input, class: 'btn') +
      template.content_tag(
        :div,
        file_path,
        class: 'file-path-wrapper',
        id: "file-#{attribute_name}"
      )
  end

  private

  def file_input
    template.content_tag(:span, "#{attribute_name}..".humanize) +
      @builder.file_field(attribute_name)
  end

  def file_path
    template.content_tag(
      :input,
      nil,
      class: 'file-path validate',
      type: 'text',
      value: object_value(object)
    )
  end

  def object_value(object)
    if object.send(attribute_name).file
      object.send(attribute_name).file.filename
    end
  end
end
