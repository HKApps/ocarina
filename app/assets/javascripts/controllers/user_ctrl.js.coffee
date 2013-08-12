ocarina.controller 'UserCtrl', ['User', '$http', '$scope',
  (User, $http, $scope) ->
    User.getCurrentUser().then (u) =>
      $scope.user = u

      $scope.user.hasPlaylists = ->
        $scope.user.playlists.length > 0

      $scope.user.hasPlaylistsAsGuest = ->
        $scope.user.playlists_as_guest.length > 0

      $scope.deferDropboxConnect = ->
        $http.post("/defer_dropbox_connect").then () =>
          $scope.user.defer_dropbox_connect = true

]
