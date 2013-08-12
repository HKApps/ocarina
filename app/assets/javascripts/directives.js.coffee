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
