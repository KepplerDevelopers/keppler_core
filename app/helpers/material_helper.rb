module MaterialHelper

	def preloader
		content_tag :div, class: "preloader-wrapper big active" do
			concat spinner_layer("blue")
			concat spinner_layer("red")
			concat spinner_layer("yellow")
			concat spinner_layer("green")
		end
	end

	private

	# dependencia de preloader
	def spinner_layer(color)
		content_tag :div, class: "spinner-layer spinner-#{color}" do
			content_tag(:div, content_tag(:div, nil, class: "circle"), class: "circle-clipper left")+
			content_tag(:div, content_tag(:div, nil, class: "circle"), class: "gap-path")+
			content_tag(:div, content_tag(:div, nil, class: "circle"), class: "circle-clipper right")
		end
	end

end
