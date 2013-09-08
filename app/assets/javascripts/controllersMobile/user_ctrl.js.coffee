ocarina.controller 'UserCtrl', ['User', 'Playlist', '$http', '$scope',
  (User, Playlist, $http, $scope) ->
    $scope.snapOpts =
      disable: 'right'

    $scope.updatePlaylists = ->
      Playlist.getIndex().then (res) =>
        $scope.playlists = res.data

    $scope.updatePlaylists()

    $scope.goToPlaylist = (playlist) ->
      return unless playlist.id
      $location.path("/playlists/#{playlist.id}")

    User.getCurrentUser().then (u) =>
      $scope.currentUser = u

      $scope.currentUser.hasPlaylists = ->
        $scope.currentUser.playlists.length > 0

      $scope.currentUser.hasPlaylistsAsGuest = ->
        $scope.currentUser.playlists_as_guest.length > 0

      $scope.deferDropboxConnect = ->
        $http.post("/defer_dropbox_connect").then () =>
          $scope.currentUser.defer_dropbox_connect = true
]
