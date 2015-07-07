module IndexHelper

	def entries(total, objects)
		total = @total if @total
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

end