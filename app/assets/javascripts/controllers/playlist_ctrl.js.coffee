ocarina.controller 'PlaylistCtrl', ['Playlist', '$scope', '$route', '$location', 'Pusher',
  (Playlist, $scope, $route, $location, Pusher) ->
    $scope.playlistId = $route.current.params.playlistId

    Playlist.get($scope.playlistId).then (p) =>
      $scope.playlist = p
      $scope.joinPlaylist(p.id) unless p.private || $scope.isMember($scope.currentUser.id)
      Playlist.getCurrentSong(p.id) unless p.owner_id == $scope.currentUser.id

    $scope.joinPlaylist = (id, password) ->
      Playlist.join(id, password).then (res) =>
        if res.status == 201
          $scope.currentUser.playlists_as_guest.push(res.data)
          $scope.playlist.guests.push($scope.currentUser)
        else
          $scope.alert =
            type: "danger"
            msg: "Oh snap... wrong password! Try again."

    $scope.isMember = (id) ->
      return unless $scope.playlist
      return true if id == $scope.playlist.owner_id
      _.findWhere $scope.playlist.guests, { id: id }

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

    ##
    # add songs modal
    $scope.openAddSongsModal = ->
      $scope.shouldBeOpen = true

    $scope.closeAddSongsModal = ->
      $scope.shouldBeOpen = false

    $scope.modalOpts = { backdropFade:true, dialogFade:true }

    $scope.showVoters = (index) =>
      $('.voters-container').eq(index).children().toggle()

    # Realtime updates
    setupPlaylistListener = (playlistChannel) ->
      playlistChannel.bind 'new-playlist-songs', (data) ->
        return if data.user_id == $scope.currentUser.id
        _.each data.playlist_songs, (song) ->
          song.current_user_vote_decision = 0
          $scope.playlist.playlist_songs.push(song)
        $scope.$apply() unless $scope.$$phase

      playlistChannel.bind 'song-played', (data) ->
        return if data.user_id == $scope.currentUser.id
        playlist = $scope.playlist.playlist_songs
        song = _.findWhere(playlist, {id: data.song_id})
        $scope.playlist.playlist_songs = _.without(playlist, song)
        $scope.playlist.currentSong = song
        $scope.$apply() unless $scope.$$phase

      playlistChannel.bind 'new-vote', (data) ->
        return if data.user_id == $scope.currentUser.id
        song = _.findWhere($scope.playlist.playlist_songs, {id: data.song_id})
        if data.action == "upvote"
          song.vote_count++
        else
          song.vote_count--
        $scope.$apply() unless $scope.$$phase

      playlistChannel.bind 'skip-song', (data) ->
        return unless $scope.playlist.owner_id == $scope.currentUser.id
        $scope.$broadcast('skip-song', data)

      playlistChannel.bind 'new-guest', (data) ->
        return if data.guest.id == $scope.currentUser.id
        $scope.playlist.guests.push data.guest
        $scope.$apply() unless $scope.$$phase

      playlistChannel.bind 'current-song-request', (data) ->
        return unless $scope.playlist.owner_id == $scope.currentUser.id
        Playlist.respondCurrentSong(data.playlist_id, $scope.playlist.currentSong)

      playlistChannel.bind 'current-song-response', (data) ->
        return if $scope.playlist.owner_id == $scope.currentUser.id
        $scope.playlist.currentSong = data.song
        $scope.$apply() unless $scope.$$phase

    # Subscribe to pusher channels
    playlistChannel = Pusher.subscribe("playlist-#{$scope.playlistId}")
    setupPlaylistListener(playlistChannel)
]
