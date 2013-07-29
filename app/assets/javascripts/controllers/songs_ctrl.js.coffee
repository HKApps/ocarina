ocarina.controller 'SongsCtrl', [ '$scope', '$http',
  ($scope, $http) ->
    $scope.openDbSongsModal = ->
      $scope.shouldBeOpen = true

    $scope.closeDbSongsModal = ->
      $scope.shouldBeOpen = false

    $scope.modalOpts = { backdropFade:true, dialogFade:true }

    $scope.refreshDropboxSongs = ->
      $http.post("/api/songs/dropbox_refresh").then (res) =>
        if res.data.status == 200
          $scope.user.dropbox_songs = res.data
]
