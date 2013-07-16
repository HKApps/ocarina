# angular app setup

window.App = angular
  .module('Ocarina', ['ngResource'])
  .config(['$locationProvider', '$routeProvider',
    ($locationProvider, $routeProvider) ->
      $locationProvider.html5Mode(true)

      $routeProvider.when '/parties/:id',
        templateURL: '/partials/parties/show.html'
  ])
