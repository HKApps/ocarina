ocarina.controller 'PlaylistCtrl', ['Playlist', '$scope', '$route', '$location',
  (Playlist, $scope, $route, $location) ->
    playlistId = $route.current.params.playlistId
    Playlist.get(playlistId).then (p) =>
      $scope.playlist = p

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
      Playlist.addSongs(playlistId, $scope.selectedSongs).then (res) =>
        _.each res.data, (song) ->
          song.current_consumer_vote_decision = 0
          $scope.playlist.playlist_songs.push(song)

      $location.path("/playlists/#{playlistId}")

    $scope.upvoteSong = (song) ->
      unless song.current_consumer_vote_decision == 1
        Playlist.vote(playlistId, song, "upvote").then (res) =>
          song.vote_count++
          song.current_consumer_vote_decision++

    $scope.downvoteSong = (song) ->
      unless song.current_consumer_vote_decision == -1
        Playlist.vote(playlistId, song, "downvote").then (res) =>
          song.vote_count--
          song.current_consumer_vote_decision--
]
