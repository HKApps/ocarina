ocarina.controller 'PartyCtrl', ['$scope', '$http', '$route', '$location',
  ($scope, $http, $route, $location) ->
    partyId = $route.current.params.partyId
    $http.get("/parties/#{partyId}.json").then (response) =>
      $scope.party = response.data

    $scope.selectedSongs = []

    $scope.isSongSelected = (song) ->
      _.any $scope.selectedSongs, (selectedSong) ->
        # TODO change this to song.id when we have it
        selectedSong == song

    $scope.toggleSongSelected = (song) ->
      if $scope.isSongSelected(song)
        $scope.selectedSongs.pop(song)
      else
        $scope.selectedSongs.push(song)

    $scope.addSelectedSongs = ->
      # TODO send $scope.selectedSongs to endpoint
      # TODO push $scope.selectedSongs to party.playlist
      future = $http.post "/parties/16/playlist/add_songs.json",
          song_ids: $scope.selectedSongs

      future.then (response) =>
        if response.status == 201
          $scope.user.parties.push(response.data)
          $location.path("/parties/#{response.data.id}/add_songs")
        # TODO else render error message

      $location.path("/parties/#{partyId}")
]
