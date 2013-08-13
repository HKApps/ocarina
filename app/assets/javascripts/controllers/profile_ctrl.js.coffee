ocarina.controller 'ProfileCtrl', ['Playlist', '$rootScope', '$scope', '$location',
  (Playlist, $rootScope, $scope, $location) ->
    $scope.createPlaylist = () ->
      playlist = new Playlist()
      playlist.name = $scope.newPlaylist.name
      playlist.create().then (res) =>
        $location.path("/playlists/#{res.data.id}")
        $scope.user.playlists.push(res.data)

      $scope.newPlaylist.name = ''
      $scope.closeCreatePlaylistModal()

    $scope.openCreatePlaylistModal = ->
      $scope.shouldBeOpen = true

    $scope.closeCreatePlaylistModal = ->
      $scope.shouldBeOpen = false

    $scope.modalOpts = { backdropFade:true, dialogFade:true }

    $scope.showSearch = ->
      $rootScope.$broadcast("showSearch")
]
