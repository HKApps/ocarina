# = require_self
# = require directives
# = require_tree ./controllers/


App.factory "pusher", ($rootScope) ->
  pusher = new Pusher("28d86c309600f754848f")

  ##
  # Uncomment this during development
  #
  # Pusher.log = (message) ->
  # window.console.log message if window.console and window.console.log

  subscribe: (channel) ->
    pusher.subscribe(channel)

  bind: (event, callback) ->
    channel.bind event, ->
      args = arguments
      $rootScope.$apply ->
        callback.apply channel, args


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
