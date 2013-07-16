#= require_self
#= require directives
#= require_tree ./controllers/

window.App = angular
  .module('Ocarina', ['ngResource'])
  .config(['$locationProvider', '$routeProvider',
    ($locationProvider, $routeProvider) ->
      $locationProvider.html5Mode(true)

      $routeProvider.when '/parties/:id',
        templateUrl: '/partials/parties/show.html'

      $routeProvider.otherwise
        redirectTo: '/'
  ])
