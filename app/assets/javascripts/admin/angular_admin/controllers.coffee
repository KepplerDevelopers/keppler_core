angular.module('admin', []).controller 'MainCtrl', [
  '$scope', "$compile", "$http", 'LxDialogService', 'LxProgressService'
  (scope, $compile, $http, dialog, LxProgressService) ->
  	# modelo para abrir y cerrar el sidebar true: open, false: close
    scope.sidebar = false

    scope.spinnerReload = ->
      $(".spinner-refresh").addClass("rotate")
      return

    #abre y cierra el sidebar
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

    #Abre el dialogo para cambia el rol de usuario
    scope.opendDialog = (dialogId)->
      dialog.open dialogId
      return

    #Accion que se activa al cerrar el dialogo para cambia el rol de usuario
    scope.closingDialog = (dialogId)->
      return

    #Configuración de progress bar con turbolinks
    jQuery(document).on 'page:fetch', ->
       LxProgressService.linear.show('#00897B', '#progress')
       return
    jQuery(document).on 'page:receive', ->
       LxProgressService.linear.hide()
      return
]

