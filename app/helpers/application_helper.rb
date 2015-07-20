module ApplicationHelper
	def title(page_title)
		content_for(:title) { page_title }
	end
	
	def	meta_description(page_description)
		content_for(:description) { page_description }
	end

	def loggedin?
		current_user
	end

	def is_index?
		action_name.to_sym.eql?(:index)
	end

	def model
		controller.controller_path.classify.constantize
	end
end
