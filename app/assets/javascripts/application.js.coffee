# = require jquery
# = require_self
# = require directives
# = require_tree ./controllers/


window.App = angular
  .module('Ocarina', ['ngResource'])
  .config(['$httpProvider', '$locationProvider'
    ($httpProvider, $locationProvider) ->
      $locationProvider.html5Mode(true)

      # Put CSRF token in all AJAX headers
      $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
  ])

