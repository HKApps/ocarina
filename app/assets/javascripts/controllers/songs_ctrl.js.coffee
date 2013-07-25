ocarina.controller 'SongsCtrl', [ '$scope', '$http',
  ($scope, $http) ->
    $scope.showDropboxSongs = false

    $scope.refreshDropboxSongs = ->
      $http.post("/api/songs/dropbox_refresh").then (res) =>
        if res.data.status == 200
          $scope.user.dropbox_songs = res.data
]
