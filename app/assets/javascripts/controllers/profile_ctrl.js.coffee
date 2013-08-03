ocarina.controller 'ProfileCtrl', ['Playlist', '$scope', '$location',
  (Playlist, $scope, $location) ->
    $scope.createPlaylist = () ->
      playlist = new Playlist()
      playlist.name = $scope.newPlaylist.name
      playlist.create().then (res) =>
        $scope.user.playlists.push(res.data)
        $location.path("/playlists/#{res.data.id}")

      $scope.newPlaylist.name = ''
      $scope.closeCreatePlaylistModal()

    $scope.openCreatePlaylistModal = ->
      $scope.shouldBeOpen = true

    $scope.closeCreatePlaylistModal = ->
      $scope.shouldBeOpen = false

    $scope.modalOpts = { backdropFade:true, dialogFade:true }
]
