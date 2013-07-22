ocarina.controller 'ProfileCtrl', ['Playlist', '$scope', '$http', '$route', '$location',
  (Playlist, $scope, $http, $route, $location) ->
    $scope.createPlaylist = () ->
      playlist = new Playlist()
      playlist.name = $scope.newPlaylist.name
      playlist.create().then (response) =>
        $scope.user.playlists.push(response.data)
        $location.path("/playlists/#{response.data.id}/add_songs")

      $scope.newPlaylist.name = ''
]
