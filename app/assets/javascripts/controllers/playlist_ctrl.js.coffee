ocarina.controller 'PlaylistCtrl', ['Playlist', '$scope', '$route', '$location', 'AudioService'
  (Playlist, $scope, $route, $location, AudioService) ->
    playlistId = $route.current.params.playlistId

    Playlist.get(playlistId).then (p) =>
      $scope.playlist = p
      song = $scope.playlist.playlist_songs.pop()
      $scope.source = "https://dl.dropboxusercontent.com/1/view/wdgou8i5w5wo3v0/Apps/PlayedBy.me/Arston%20-%20Zodiac%20%5BEDX%20No%20Xcuses%20113%204-28-13%5D.mp3"

    ##
    # Add Songs Modal
    $scope.openAddSongsModal = ->
      $scope.shouldBeOpen = true

    $scope.closeAddSongsModal = ->
      $scope.shouldBeOpen = false

    $scope.modalOpts = { backdropFade:true, dialogFade:true }

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
      $scope.closeAddSongsModal()
      Playlist.addSongs(playlistId, $scope.selectedSongs).then (res) =>
        _.each res.data, (song) ->
          song.current_consumer_vote_decision = 0
          $scope.playlist.playlist_songs.push(song)

    ##
    # Voting
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
