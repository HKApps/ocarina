ocarina.controller 'PlaylistCtrl', ['$scope', '$http', '$route', '$location',
  ($scope, $http, $route, $location) ->
    playlistId = $route.current.params.playlistId
    $http.get("/playlists/#{playlistId}.json").then (response) =>
      $scope.playlist = response.data

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
      future = $http.post "/playlists/#{playlistId}/playlist/add_songs.json",
          song_ids: $scope.selectedSongs

      future.then (response) =>
        if response.status == 201
          _.each response.data, (songToAdd) ->
            $scope.playlist.playlists.push(songToAdd)
        # TODO else render message

        $location.path("/playlists/#{playlistId}")

    $scope.upvoteSong = (song) ->
      upvotedSong = _.findWhere($scope.playlist.playlists, song)
      upvotedSong.up_votes++
      # submit vote to server?

    $scope.downvoteSong = (song) ->
      downvotedSong = _.findWhere($scope.playlist.playlists, song)
      downvotedSong.down_votes++
      # submit vote to server?
]
