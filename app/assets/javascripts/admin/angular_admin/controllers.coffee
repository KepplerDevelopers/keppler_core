app.controller 'MainCtrl', [
	'$scope', "$compile", "$http", "$timeout", 'MainService'
	(scope, $compile, $http, $timeout, MainService) ->
		# modelo para abrir y cerrar el sidebar true: open, false: close
		scope.sidebar = false
		scope.btnDelete = false
		scope.check = []
		scope.iconCheck = "check_box_outline_blank"
		scope.tooltipCheck = "Seleccionar todo"

		scope.selectByCheck = (usersCount)->
			MainService.selectByCheckService(scope, usersCount)
			return

		scope.selectAll = (users)->
			MainService.selectAllService(scope, users)
			return

		scope.searchSiwtch = ->
			scope.inputSearch = !scope.inputSearch
			return

		scope.searchSiwtch = ->
			scope.inputSearch = !scope.inputSearch
			return

		scope.spinnerReload = ->
			$(".spinner-refresh").addClass("rotate")
			return

		#abre y cierra el sidebar y agrega efectos a el icon
		scope.sidebarSwitch = ->
			scope.sidebar = !scope.sidebar
			return

		#cerrar sidebar si hace click en el main de la aplicación
		scope.sidebarClose = ->
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

