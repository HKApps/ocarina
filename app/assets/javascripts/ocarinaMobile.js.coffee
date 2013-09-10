# sets up angular app
@ocarina = angular
  .module('ocarinaMobile', ['ocarinaServices', 'ocarinaFilters', 'ocarinaDirectives', 'ui.bootstrap', 'snap'])
  .config(['$locationProvider', '$routeProvider', '$httpProvider',
    ($locationProvider, $routeProvider, $httpProvider) ->

      $locationProvider.html5Mode(true)

      $routeProvider
        .when '/',
          templateUrl: '/partials/mobile/home.html'
        .when '/playlists/new',
          templateUrl: '/partials/mobile/playlists/new.html'
        .when '/playlists/:playlistId/add_songs',
          templateUrl: '/partials/mobile/playlists/add_songs.html'
        .when '/playlists/:playlistId',
          templateUrl: '/partials/mobile/playlists/show.html'
        # .when '/favorites',
        #   templateUrl: '/partials/favorites.html'
        # .when '/search',
        #   templateUrl: '/partials/mobile/search.html'
        # .when '/:userId',
        #   templateUrl: '/partials/profile.html'
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
