angular.module('keppler', [
	'admin'
	'pageslide-directive'
]).config [
	'$httpProvider'
	(provider) ->
		# permite leer csrf token y añadirlo al ajax de angular para poder autenticar la seguridad de la aplicación
		provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
		return
	]

# iniciar ng-app mediante turbolinks
$(document).on 'ready page:load', () ->		
		angular.bootstrap document.body, [ 'keppler' ]
		$('#waiting').remove()
	return