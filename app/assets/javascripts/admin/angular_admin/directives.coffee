app.directive 'resize', ->
  (scope, element) ->
    w = angular.element($(window))

    scope.getWindowDimensions = ->
      {
        'h': w.height()
        'w': w.width()
      }

    scope.$watch scope.getWindowDimensions, ((newValue, oldValue) ->
      scope.windowHeight = newValue.h-129
      scope.windowWidth = newValue.w

      scope.style = ->
        {
          'height': newValue.h+'px'
          'width': newValue.w+'px'
        }

      return
    ), true
    w.bind 'resize', ->
      scope.$apply()
      return
    return

