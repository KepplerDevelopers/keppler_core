app.service 'MainService', [
	'$http'
	'localStorageService'
	(http, localStorage)->

		this.selectOptions = (scope, users, button)->
			if button == "check"
				if scope.check.length > 0
					scope.btnDelete = true
					scope.iconCheck = "indeterminate_check_box"
					scope.tooltipCheck = "Deseleccionar"
					if scope.check.length == users
						scope.iconCheck = "check_box"
						scope.tooltipCheck = "Deseleccionar todo"
				else
					scope.btnDelete = false
					scope.iconCheck = "check_box_outline_blank"
					scope.tooltipCheck = "Seleccionar todo"
			if button == "btn"
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