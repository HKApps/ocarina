# sets up angular app
@ocarina = angular
  .module('ocarina', ['ocarinaServices', 'ocarinaFilters', 'ocarinaDirectives', 'ui.bootstrap'])
  .config(['$locationProvider', '$routeProvider', '$httpProvider',
    ($locationProvider, $routeProvider, $httpProvider) ->

      $locationProvider.html5Mode(true)

      $routeProvider
        .when '/playlists/:playlistId',
          templateUrl: '/partials/playlists/show.html'
        .when '/',
          templateUrl: '/partials/profile.html'
        .otherwise
          redirectTo: '/'
  ])
  .run(['$rootScope', '$location', ($rootScope, $location) ->
    $rootScope.location = $location
  ])
