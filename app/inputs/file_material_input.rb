class FileMaterialInput < SimpleForm::Inputs::Base
  def input(wrapper_options = nil)
  	template.content_tag(:div, file_input, class: "btn")+
  	template.content_tag(:div, template.content_tag(:input, nil, class: "file-path validate", type: "text", value: eval("object.#{attribute_name}.file ? object.#{attribute_name}.file.filename : nil")), class: "file-path-wrapper", id: "file-#{attribute_name}")
  end

  private 

  def file_input
  	template.content_tag(:span, "#{attribute_name}..")+
  	@builder.file_field(attribute_name)
  end
end
