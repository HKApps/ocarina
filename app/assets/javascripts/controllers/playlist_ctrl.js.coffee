ocarina.controller 'PlaylistCtrl', ['Playlist', '$scope', '$route', '$location', 'Pusher',
  (Playlist, $scope, $route, $location, Pusher) ->
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
      $scope.closeAddSongsModal()
      Playlist.addSongs(playlistId, $scope.selectedSongs).then (res) =>
        _.each res.data, (song) ->
          song.current_user_vote_decision = 0
          $scope.playlist.playlist_songs.push(song)

    $scope.upvoteSong = (song) ->
      unless song.current_user_vote_decision == 1
        Playlist.vote(playlistId, song.id, "upvote").then (res) =>
          song.vote_count++
          song.current_user_vote_decision++

    $scope.downvoteSong = (song) ->
      unless song.current_user_vote_decision == -1
        Playlist.vote(playlistId, song.id, "downvote").then (res) =>
          song.vote_count--
          song.current_user_vote_decision--

    $scope.openAddSongsModal = ->
      $scope.shouldBeOpen = true

    $scope.closeAddSongsModal = ->
      $scope.shouldBeOpen = false

    $scope.modalOpts = { backdropFade:true, dialogFade:true }

    # Realtime - for news songs, played songs, and votes
    setupPlaylistListener = (playlistChannel) ->
      playlistChannel.bind 'new-playlist-songs', (data) ->
        return if data.user_id == $scope.user.id
        _.each data.playlist_songs, (song) ->
          $scope.playlist.playlist_songs.push(song)
        $scope.$apply() unless $scope.$$phase

      playlistChannel.bind 'song-played', (data) ->
        return if data.user_id == $scope.user.id
        playlist = $scope.playlist.playlist_songs
        song = _.findWhere(playlist, {id: data.song_id})
        $scope.playlist.playlist_songs = _.without(playlist, song)
        $scope.$apply() unless $scope.$$phase

      playlistChannel.bind 'new-vote', (data) ->
        return if data.user_id == $scope.user.id
        song = _.findWhere($scope.playlist.playlist_songs, {id: data.song_id})
        if data.action == "upvote"
          song.vote_count++
        else
          song.vote_count--
        $scope.$apply() unless $scope.$$phase

    # Subscribe to pusher channels
    playlistChannel = Pusher.subscribe("playlist-#{playlistId}")
    setupPlaylistListener(playlistChannel)
]
