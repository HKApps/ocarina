ocarina.controller 'ProfileCtrl', ['Playlist', '$scope', '$location',
  (Playlist, $scope, $location) ->
    $scope.createPlaylist = () ->
      playlist = new Playlist()
      playlist.name = $scope.newPlaylist.name
      playlist.create().then (p) =>
        $scope.user.playlists.push(p)
        $location.path("/playlists/#{p.id}/add_songs")

      $scope.newPlaylist.name = ''
]
