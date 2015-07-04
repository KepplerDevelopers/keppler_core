module IndexHelper

	#listing-index
	def wrapper(other_class = nil, &block)
		content_tag :div, capture(other_class,&block), class: "#{other_class}"
	end

	def header(other_class = nil, &block)
		content_tag :div, capture(&block), class: "#{other_class}"
	end

	def listing_body(other_class =  nil, &block)
		content_tag :div, capture(&block), class: "listing-body #{other_class}"
	end

	def entries(total, objects)
		unless total.zero?
			content_tag :div, class: "entries hidden-xs" do
				if objects.first_page?
					"1 al #{objects.count} de #{total} registros"
				elsif objects.last_page?
					"#{((objects.current_page * objects.default_per_page) - objects.default_per_page)+1} al #{total} de #{total} registros"
				else
					"#{((objects.current_page * objects.default_per_page) - objects.default_per_page)+1} al #{objects.current_page * objects.default_per_page} de #{total} registros"
				end
			end
		end
	end

	#show-index
	def show_index(&block)
		content_tag :div, class: "item show card", &block
	end

	def show_header(&block)
		content_tag :div, class: "p+ show-header" do
			content_tag(:div, class: "action", &block)+
			content_tag(:h1) do
				icon(:"account")+" "+t("model.singular.#{controller_name.singularize}")
			end
		end	
	end

	def show_body(html_options = {}, &block)
		content_tag :div, html_options.merge!(class: "show-body") do
			content_tag :div, class: "description" do
				capture(&block)
			end
		end
	end

	def list_row(&block)
		content_tag :li, class: "list-row" do
			content_tag :div, capture(&block), class: "list-row__content"
		end
	end

end