ocarina.controller 'SongsCtrl', [ '$scope', '$http', '$location', '$route',
  ($scope, $http, $location, $route) ->
    # TODO move this to /users/:id/songs.json

    $http.get("/dropbox.json").then (response) =>
      $scope.songs = response.data.contents

    $scope.selectedSongs = []

    $scope.isSongSelected = (song) ->
      _.any $scope.selectedSongs, (selectedSong) ->
        # TODO change this to song.id when we have it
        selectedSong.path == song.path

    $scope.toggleSongSelected = (song) ->
      if $scope.isSongSelected(song)
        $scope.selectedSongs.pop(song)
      else
        $scope.selectedSongs.push(song)

    $scope.addSelectedSongs = ->
      # TODO send $scope.selectedSongs to endpoint
      # TODO push $scope.selectedSongs to party.playlist
      partyId = $route.current.params.partyId
      $location.path("/parties/#{partyId}")
]
