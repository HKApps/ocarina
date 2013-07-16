# = require jquery
# = require_self
# = require directives
# = require_tree ./controllers/


window.App = angular
  .module('Ocarina', ['ngResource'])
  .config(['$httpProvider', '$locationProvider'
    ($httpProvider, $locationProvider) ->
      $locationProvider.html5Mode(true)

  ])

