class FileMaterialInput < SimpleForm::Inputs::Base
  def input
  	template.content_tag(:div, file_input, class: "btn")+
  	template.content_tag(:div, template.content_tag(:input, nil, class: "file-path validate", type: "text"), class: "file-path-wrapper")
  end

  private 

  def file_input
  	template.content_tag(:span, "#{attribute_name}..")+
  	@builder.file_field(attribute_name)
  end
end