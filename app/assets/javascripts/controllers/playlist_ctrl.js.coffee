ocarina.controller 'PlaylistCtrl', ['Playlist', '$scope', '$route', '$location', 'Pusher',
  (Playlist, $scope, $route, $location, Pusher) ->
    $scope.playlistId = $route.current.params.playlistId

    Playlist.get($scope.playlistId).then (p) =>
      $scope.playlist = p

    $scope.upvoteSong = (song) ->
      return if song.current_user_vote_decision == 1
      Playlist.vote($scope.playlistId, song.id, "upvote")
      song.vote_count++
      song.current_user_vote_decision++

    $scope.downvoteSong = (song) ->
      return if song.current_user_vote_decision == -1
      Playlist.vote($scope.playlistId, song.id, "downvote")
      song.vote_count--
      song.current_user_vote_decision--

    $scope.skipSongVote = (song) ->
      Playlist.skipSongVote($scope.playlistId, song.id)

    $scope.openAddSongsModal = ->
      $scope.shouldBeOpen = true

    $scope.closeAddSongsModal = ->
      $scope.shouldBeOpen = false

    $scope.modalOpts = { backdropFade:true, dialogFade:true }

    # Realtime updates
    setupPlaylistListener = (playlistChannel) ->
      playlistChannel.bind 'new-playlist-songs', (data) ->
        return if data.user_id == $scope.user.id
        _.each data.playlist_songs, (song) ->
          song.current_user_vote_decision = 0
          $scope.playlist.playlist_songs.push(song)
        $scope.$apply() unless $scope.$$phase

      playlistChannel.bind 'song-played', (data) ->
        return if data.user_id == $scope.user.id
        playlist = $scope.playlist.playlist_songs
        song = _.findWhere(playlist, {id: data.song_id})
        $scope.playlist.playlist_songs = _.without(playlist, song)
        $scope.playlist.currentSong = song
        $scope.$apply() unless $scope.$$phase

      playlistChannel.bind 'new-vote', (data) ->
        return if data.user_id == $scope.user.id
        song = _.findWhere($scope.playlist.playlist_songs, {id: data.song_id})
        if data.action == "upvote"
          song.vote_count++
        else
          song.vote_count--
        $scope.$apply() unless $scope.$$phase

      playlistChannel.bind 'skip-song', (data) ->
        $scope.$broadcast('skip-song', data)

      playlistChannel.bind 'new-guest', (data) ->
        return if data.guest.id == $scope.user.id
        $scope.playlist.guests.push data.guest
        $scope.$apply() unless $scope.$$phase

    # Subscribe to pusher channels
    playlistChannel = Pusher.subscribe("playlist-#{$scope.playlistId}")
    setupPlaylistListener(playlistChannel)
]
