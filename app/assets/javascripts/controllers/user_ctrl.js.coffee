ocarina.controller 'UserCtrl', ['User', '$scope',
  (User, $scope) ->
    User.getCurrentUser().then (u) =>
      $scope.user = u

      $scope.user.hasPlaylists = ->
        $scope.user.playlists.length > 0

      $scope.user.hasPlaylistsAsGuest = ->
        $scope.user.playlists_as_guests.length > 0

      $scope.hasDropboxAuth = $scope.user.dropbox_authenticated

]
