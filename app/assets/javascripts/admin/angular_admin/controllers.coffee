angular.module('admin', []).controller 'MainCtrl', [
	'$scope', "$compile", "$http", "$timeout"
	(scope, $compile, $http, $timeout) ->
		# modelo para abrir y cerrar el sidebar true: open, false: close
		scope.sidebar = false

		scope.searchSiwtch = ->
			scope.inputSearch = !scope.inputSearch
			return

		scope.spinnerReload = ->
			$(".spinner-refresh").addClass("rotate")
			return

		#abre y cierra el sidebar y agrega efectos a el icon
		scope.sidebarSwitch = ->
			scope.sidebar = !scope.sidebar
			if scope.sidebar
				$('.switch i').text("arrow_back").addClass("slideInRight")
				$timeout (->
					$('.switch i').text("arrow_back").removeClass("slideInRight")
					return
				),1000
			else
				$('.switch i').text("menu").addClass("slideInLeft")
				$timeout (->
					$('.switch i').text("menu").removeClass("slideInLeft")
					return
				),1000
			return

		#cerrar sidebar si hace click en el main de la aplicación
		scope.sidebarClose = ->
			if scope.sidebar
				$('.switch i').text("menu").addClass("slideInLeft")
				$timeout (->
					$('.switch i').text("menu").removeClass("slideInLeft")
					return
				),1000
			scope.sidebar = false
			return

		#metodo para compilar html agregado desde jquery
		scope.compiledHTML = (el) ->
			$compile(el)(scope)
			scope.$apply
			return 

		#Configuración de progress bar con turbolinks
		jQuery(document).on 'page:fetch', ->
			 
			 return
		jQuery(document).on 'page:receive', ->
			 
			return
]

