# sets up angular app
@ocarina = angular
  .module('ocarina', ['ocarinaServices', 'ocarinaFilters', 'ocarinaDirectives', 'ui.bootstrap'])
  .config(['$locationProvider', '$routeProvider', '$httpProvider',
    ($locationProvider, $routeProvider, $httpProvider) ->

      $locationProvider.html5Mode(true)

      $routeProvider
        .when '/playlists/:playlistId',
          templateUrl: '/partials/playlists/show.html'
        .when '/search',
          templateUrl: '/partials/search.html'
        .when '/',
          templateUrl: '/partials/profile.html'
        .otherwise
          redirectTo: '/'
  ])
  .run(['$rootScope', '$location', ($rootScope, $location) ->
    $rootScope.location = $location
    $rootScope.isMobilized = isMobilized()
    $rootScope.isiOS = isiOS()
    window.onresize = ->
      $rootScope.isMobilized = isMobilized()
      $rootScope.$apply()
  ])

# set mobile class
if navigator.userAgent.match(/Android|BlackBerry|iPhone|iPod|iPad|IEMObile/i)
  $('body').addClass('is-touch')
else
  $('body').addClass('is-pointer')

# bc iOS is for chumps
isiOS = ->
  if navigator.userAgent.match(/iPhone|iPod|iPad/i)
    true
  else
    false

isMobilized = ->
  $(window).width() <= 768 ? true : false
