ocarina.controller 'SongsCtrl', [ '$scope', '$http', "User",
  ($scope, $http, User) ->
    $scope.openDbSongsModal = ->
      unless $scope.user.dropbox_songs.length
        # TODO get songs from songs endpoint instead
        User.getCurrentUser().then (u) =>
          $scope.user.dropbox_songs = u.dropbox_songs
      $scope.shouldBeOpen = true

    $scope.closeDbSongsModal = ->
      $scope.shouldBeOpen = false

    $scope.modalOpts = { backdropFade:true, dialogFade:true }

    $scope.refreshDropboxSongs = ->
      $http.post("/api/songs/dropbox_refresh").then (res) =>
        if res.data.status == 200
          $scope.user.dropbox_songs = res.data
]
