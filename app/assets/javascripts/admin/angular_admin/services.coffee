app.service 'MainService', [
	'$http'
	'localStorageService'
	(http, localStorage)->

		this.selectByCheckService = (scope, usersCount)->
			if scope.check.length > 0
				scope.btnDelete = true
				scope.iconCheck = "indeterminate_check_box"
				scope.tooltipCheck = "Deseleccionar"
				console.log usersCount
				if scope.check.length == usersCount
					scope.iconCheck = "check_box"
					scope.tooltipCheck = "Deseleccionar todo"
			else
				scope.btnDelete = false
				scope.iconCheck = "check_box_outline_blank"
				scope.tooltipCheck = "Seleccionar todo"				
			return

		this.selectAllService = (scope, users)->
			if scope.check.length == 0
					users.filter (element)->
						scope.check.push element.id
						return
					scope.btnDelete = true
					scope.iconCheck = "check_box"
					scope.tooltipCheck = "Deseleccionar todo"
				else
					scope.check = []
					scope.iconCheck = "check_box_outline_blank"
					scope.tooltipCheck = "Seleccionar todo"
					scope.btnDelete = false
			return
		return
]