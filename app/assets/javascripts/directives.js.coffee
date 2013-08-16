ocarinaDirectives = angular.module('ocarinaDirectives', [])

ocarinaDirectives.directive 'dropboxAuth', ->
  (scope, $elm, attr) ->
    $elm.on 'click', ->
      window.location.replace("/auth/dropbox")

ocarinaDirectives.directive 'onReturn', ->
  (scope, $elm, attr) ->
    $elm.bind 'keydown', (e) ->
      if e.keyCode == 13 && !e.shiftKey && !e.altKey
        e.preventDefault()
        scope.$apply(attr.onReturn)

ocarinaDirectives.directive 'onInput', ->
  (scope, $elm, attr) ->
    $elm.on 'keydown', ->
      scope.$apply(attr.onInput)

ocarinaDirectives.directive 'onDebouncedKeyup', ->
  (scope, $elm, attr) ->
    debouncedApply = _.debounce ->
      scope.$apply(attr.onDebouncedKeyup)
    , 300
    $elm.bind('keyup', debouncedApply)

ocarinaDirectives.directive 'onFocus', ->
  (scope, $elm, attr) ->
    $elm.on 'focusin', ->
      scope.$apply(attr.onFocus)

ocarinaDirectives.directive 'onBlur', ->
  (scope, $elm, attr) ->
    $elm.on 'blur', ->
      scope.$apply(attr.onBlur)

ocarinaDirectives.directive 'onClickFocus', ->
  (scope, $elm, attr) ->
    $elm.on 'click', ->
      $(attr.onClickFocus).focus()

# will end up removing this when upgrading angular
ocarinaDirectives.directive "ocarinaIf", ->
  transclude: "element"
  priority: 1000
  terminal: true
  restrict: "A"
  compile: (element, attr, transclude) ->
    (scope, element, attr) ->
      childElement = undefined
      childScope = undefined
      scope.$watch attr.ocarinaIf, (newValue) ->
        if childElement
          childElement.remove()
          childElement = `undefined`
        if childScope
          childScope.$destroy()
          childScope = `undefined`
        if newValue
          childScope = scope.$new()
          transclude childScope, (clone) ->
            childElement = clone
            element.after clone

ocarinaDirectives.directive 'seekProgressBar', ->
  (scope, $elm, attr) ->
    $elm.on 'mousedown', (e) ->
      scope.timeDrag = true
      scope.updatebar e.pageX
    $elm.on 'mouseup', (e) ->
      if scope.timeDrag
        scope.timeDrag = false
        scope.updatebar e.pageX
    $elm.on 'mousemove', (e) ->
      scope.updatebar e.pageX if scope.timeDrag
