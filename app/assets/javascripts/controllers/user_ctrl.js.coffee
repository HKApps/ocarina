ocarina.controller 'UserCtrl', ['$scope', '$http', 'User', 'Authentication',
  ($scope, $http, User, Authentication) ->
    $scope.auth = Authentication

    if Authentication.getCookie("user_id")
      $scope.currentUser =
        id: parseInt(Authentication.getCookie("user_id"))
      Authentication.loggedIn = true
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
