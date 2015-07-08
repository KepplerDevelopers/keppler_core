app.controller 'MainCtrl', [
	'$scope', "$compile", "$http", "$timeout", 'MainService'
	(scope, $compile, $http, $timeout, MainService) ->
		# modelo para abrir y cerrar el sidebar true: open, false: close
		scope.sidebar = false
		scope.btnDelete = false
		scope.check = []
		scope.iconCheck = "check_box_outline_blank"

		scope.checkChanged = ->
			MainService.addRemoveButtonInNavbar(scope)
			return

		scope.select = (users, button)->
			MainService.selectOptions(scope, users, button)
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
			if scope.sidebar
				$('.switch i').text("arrow_back").addClass("bounceInRight")
				$timeout (->
					$('.switch i').text("arrow_back").removeClass("bounceInRight")
					return
				),1000
			else
				$('.switch i').text("menu").addClass("bounceInLeft")
				$timeout (->
					$('.switch i').text("menu").removeClass("bounceInLeft")
					return
				),1000
			return

		#cerrar sidebar si hace click en el main de la aplicación
		scope.sidebarClose = ->
			if scope.sidebar
				$('.switch i').text("menu").addClass("bounceInLeft")
				$timeout (->
					$('.switch i').text("menu").removeClass("bounceInLeft")
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

