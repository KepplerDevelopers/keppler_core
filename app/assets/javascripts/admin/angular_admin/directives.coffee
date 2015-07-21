app.directive 'resize', ->
  (scope, element) ->
    w = angular.element($(window))

    scope.getWindowDimensions = ->
      {
        'h': w.height()
        'w': w.width()
      }

    scope.$watch scope.getWindowDimensions, ((newValue, oldValue) ->
      scope.windowHeight = newValue.h
      scope.windowWidth = newValue.w

      scope.style = ->
        {
          'height': newValue.h - 100 + 'px'
          'width': newValue.w - 100 + 'px'
        }

      return
    ), true
    w.bind 'resize', ->
      scope.$apply()
      return
    return

