app.service 'MainService', [
	'$http'
	'localStorageService'
	(http, localStorage)->

		this.selectOptions = (scope, users, button)->
			if button == "check"
				if scope.check.length > 0
					scope.btnDelete = true
					scope.iconCheck = "indeterminate_check_box"
					if scope.check.length == users.length
						scope.iconCheck = "check_box"
				else
					scope.btnDelete = false
					scope.iconCheck = "check_box_outline_blank"
			if button == "btn"
				if scope.check.length == 0
					users.filter (element)->
						scope.check.push element.id
						return
					scope.btnDelete = true
					scope.iconCheck = "check_box"
				else
					scope.check = []
					scope.iconCheck = "check_box_outline_blank"
					scope.btnDelete = false
			return

		return
]