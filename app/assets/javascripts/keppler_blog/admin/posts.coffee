$(document).on 'ready page:load', () ->
	$('#post_category_id').change ->
	  $.ajax
	    url: '/admin/blog/posts/find/subcategories'
	    type: 'GET'
	    data: 'category_id=' + $('#post_category_id option:selected').val()
	  return
	return