module IndexHelper

	def entries(total, objects)
		unless total.zero?
			content_tag :div, class: "entries hidden-xs" do
				if objects.first_page?
					"1 al #{objects.size} de #{total} #{t("keppler.messages.records")}"
				elsif objects.last_page?
					"#{((objects.current_page * objects.default_per_page) - objects.default_per_page)+1} al #{total} de #{total} #{t("keppler.messages.records")}"
				else
					"#{((objects.current_page * objects.default_per_page) - objects.default_per_page)+1} al #{objects.current_page * objects.default_per_page} de #{total} #{t("keppler.messages.records")}"
				end
			end
		end
	end

end