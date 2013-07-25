ocarinaDirectives = angular.module('ocarinaDirectives', [])

ocarinaDirectives.directive 'dropboxAuth', ->
  (scope, $elm, attr) ->
    $elm.on 'click', ->
      window.location.replace("/auth/dropbox")
