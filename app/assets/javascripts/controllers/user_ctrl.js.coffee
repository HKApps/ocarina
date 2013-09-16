ocarina.controller 'UserCtrl', ['$scope', '$http', 'User', 'Authentication',
  ($scope, $http, User, Authentication) ->
    $scope.loggedIn = Authentication.loggedIn

    $scope.logout = ->
      Authentication.logout()

    $scope.login = ->
      Authentication.login()

    if Authentication.getCookie("user_id")
      $scope.loggedIn = true
      User.get(Authentication.getCookie("user_id")).then (u) =>
        $scope.currentUser = u

        $scope.currentUser.hasPlaylists = ->
          $scope.currentUser.playlists.length > 0

        $scope.currentUser.hasPlaylistsAsGuest = ->
          $scope.currentUser.playlists_as_guest.length > 0

        $scope.deferDropboxConnect = ->
          $http.post("/defer_dropbox_connect").then () =>
            $scope.currentUser.defer_dropbox_connect = true
]
