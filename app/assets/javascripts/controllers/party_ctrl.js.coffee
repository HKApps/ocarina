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
      # Uncomment when add_songs works
      # future = $http.post "/parties/16/playlist/add_songs.json",
      #     song_ids: $scope.selectedSongs

      # future.then (response) =>
      #   if response.status == 201
      #     $scope.party.playlists.push(response.data)
      #   # TODO else render error message

      $location.path("/parties/#{partyId}")

    # TODO test
    $scope.upvoteSong = (song) ->
      _.findWhere $scope.party.playlists, (upvotedSong) ->
        upvotedSong++
        # submit vote to server?

    $scope.upvoteSong = (song) ->
      _.findWhere $scope.party.playlists, (upvotedSong) ->
        upvotedSong--
        # submit vote to server?
]
