ocarina.controller 'SongsCtrl', [ '$scope', '$http',
  ($scope, $http) ->
    $scope.showDropboxSongs = false

    $scope.refreshDropboxSongs = ->
      %http.get("insert url").then (res) =>
        unless res.data.status == 304 # not modified
          _.each res.data, (song) ->
            $scope.user.dropbox_songs.push(song)
]
