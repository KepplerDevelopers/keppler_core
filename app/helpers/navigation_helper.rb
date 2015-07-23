module NavigationHelper
	def tab(name, icon, link, current)	
		content_tag :li do
			link_to link, class: "collapsible-header #{'current' if controller_path == current }" do
      	content_tag(:i, icon, class: "mi md-18")+
        name
      end
		end
	end
end