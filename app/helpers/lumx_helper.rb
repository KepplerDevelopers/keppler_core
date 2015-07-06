module LumxHelper

	#container-flex
	def lumx_flex_container(direction, html_options = {}, &block)
		content_tag :div, capture(&block), html_options.merge!("flex-container" => direction)
	end

	#item-flex
	def lumx_flex_item(flex_item = 12, flex_item_order = 1, html_options = {}, &block)
		content_tag :div, capture(&block), html_options.merge!("flex-item" => flex_item, "flex-item-order" => flex_item_order)
	end

	#icons
	def icon(icon, other_class = nil, html_options = {})
		content_tag :i, nil, html_options.merge!(class: "mdi mdi-#{icon.to_s} #{other_class}")
	end

	#floating-button
	def lumx_floating_button(url)
		link_to url, class: "btn btn--xl bgc-teal-600 btn--fab btn-new hidden-xs", "lx-ripple"=>"" do
			content_tag :i, nil, class: "mdi mdi-plus tc-white"
		end
	end

	def buttons_attributes(tooltip_text = nil, tooltip_position = nil, html_options = {})
		html_options.merge!(class: "tc-white btn btn--l btn--black btn--icon", "lx-ripple" => true, "lx-tooltip"=>tooltip_text, "tooltip-position"=>tooltip_position)
	end

	#dropdown
	def lumx_dropdown(&block)
		content_tag "lx-dropdown", "from-top" => "", position: "right" do
			content_tag(:button, icon(:"dots-vertical"), class: "tc-white btn btn--l btn--black btn--icon", "lx-dropdown-toggle" => true, "lx-ripple" => true)+
			content_tag("lx-dropdown-menu", content_tag(:ul, capture(&block)))
		end
	end

	#inputs
	def lumx_textfield(name, error=false, &block) #from_tag
		content_tag "lx-text-field", label: "#{name}", error: error, &block
	end

	def lumx_text_field(f, name, type, label, wrapper=  nil, html_options = {}) #simple_form
		f.input name, as: type, lx_text_field_html: { label: label, error: (f.object.errors.messages[name] ? true : false) }, wrapper: wrapper, input_html: html_options.merge!("ng-model" => "#{name} = #{f.object.send(name)}")
	end

	def lumx_select_field(f, name, placeholder, collection, value) #simple_form
		content_tag "lx-select", "floating-label" => "", "ng-model" => "selected", :placeholder => placeholder, "ng-init"=>"objects = #{collection}; selected = #{value}", choices: "objects" do
			content_tag("lx-select-selected", "{{ $selected.name }}")+
			content_tag("lx-select-choices", "{{ $choice.name }}")+
			f.input(name, as: :hidden, input_html: { value: "{{selected.id}}" })
		end
	end

	#table
	def lumx_table(other_class = nil, html_options = {}, &block)
		content_tag :div, class: "data-table-container" do
			content_tag :table, capture(&block), html_options.merge!(class: "data-table #{other_class}")
		end
	end

	def lumx_table_head(other_class = nil, html_options = {}, &block)
		content_tag :thead, capture(&block), html_options.merge!(class: "#{other_class}")		
	end

	def lumx_table_body(other_class = nil, html_options = {}, &block)
		content_tag :tbody, capture(&block), html_options.merge!(class: "#{other_class}")				
	end

	def lumx_table_tr(other_class = nil, html_options = {}, &block)
		content_tag :tr, capture(&block), html_options.merge!(class: "data-table__clickable-row listing-row #{other_class}")
	end

	def lumx_checkbox_tag(html_options = {}, &block)
		content_tag :div, class: "checkbox" do
			content_tag(:input, nil, type: "checkbox", id: html_options[:id], class: "checkbox__input #{html_options[:class]}")+
			content_tag(:label, capture(&block),for: html_options[:id], class: "checkbox__label #{html_options[:class]}")
		end
	end
end
