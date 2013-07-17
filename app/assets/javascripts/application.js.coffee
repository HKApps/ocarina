#= require_self
#= require directives
#= require_tree ./controllers/
#= require services
#= require directives
#= require feeds
#= require filters

window.App = angular
  .module('ocarina', ['ocarinaServices', 'ocarinaFeeds', 'ocarinaFilters', 'ocarinaDirectives'])
  .config(['$locationProvider', '$routeProvider',
    ($locationProvider, $routeProvider) ->

      $locationProvider.html5Mode(true)

      $routeProvider.when '/parties/:partyId',
        templateUrl: '/partials/parties/show.html'

      $routeProvider.otherwise
        redirectTo: '/'
  ])
