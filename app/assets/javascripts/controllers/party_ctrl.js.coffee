ocarina.controller 'PartyCtrl', ['$scope', '$http', '$route', '$location',
  ($scope, $http, $route, $location) ->
    partyId = $route.current.params.partyId
    $http.get("/parties/#{partyId}.json").then (response) =>
      $scope.party = response.data

    $scope.selectedSongs = []

    $scope.isSongSelected = (song) ->
      _.any $scope.selectedSongs, (selectedSong) ->
        selectedSong == song

    $scope.toggleSongSelected = (song) ->
      if $scope.isSongSelected(song)
        $scope.selectedSongs.pop(song)
      else
        $scope.selectedSongs.push(song)

    $scope.addSelectedSongs = ->
      future = $http.post "/parties/#{partyId}/playlist/add_songs.json",
          song_ids: $scope.selectedSongs

      future.then (response) =>
        if response.status == 201
          _.each response.data, (songToAdd) ->
            $scope.party.playlists.push(songToAdd)
        # TODO else render message

        $location.path("/parties/#{partyId}")

    $scope.upvoteSong = (song) ->
      upvotedSong = _.findWhere($scope.party.playlists, song)
      upvotedSong.up_votes++
      # submit vote to server?

    $scope.downvoteSong = (song) ->
      downvotedSong = _.findWhere($scope.party.playlists, song)
      downvotedSong.down_votes++
      # submit vote to server?
]
