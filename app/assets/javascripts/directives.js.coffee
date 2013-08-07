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
