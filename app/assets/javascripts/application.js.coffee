#= require_self
#= require directives
#= require_tree ./controllers/
#= require services
#= require directives
#= require filters
#= require jquery
# = require zepto/default
# = require "foundation"

window.App = angular
  .module('ocarina', ['ocarinaServices', 'ocarinaFilters', 'ocarinaDirectives'])
  .config(['$locationProvider', '$routeProvider', '$httpProvider',
    ($locationProvider, $routeProvider, $httpProvider) ->

      $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')

      $locationProvider.html5Mode(true)

      $routeProvider.when '/parties/:partyId',
        templateUrl: '/partials/parties/show.html'

      $routeProvider.otherwise
        redirectTo: '/'
  ])

# Setups foundation
$ ->
  $(document).foundation()


