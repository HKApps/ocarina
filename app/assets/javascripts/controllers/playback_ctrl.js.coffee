ocarina.controller 'PlaybackCtrl', ['$scope', '$http', '$route', 'Playlist', 'Player',
  ($scope, $http, $route, Playlist, Player) ->
    $scope.playlistId = $route.current.params.playlistId

    ##
    # Audo Playback
    $scope.player = Player

    # add event listeners
    $scope.$on "audioEnded", ->
      if $scope.isPlayingPlaylist()
        $scope.playerAction("play")
      else
        # TODO maybe get song from playlist_songs?
        Player.stop()
        initializePlayer()
    $scope.$on "audioError", ->
      # because errors typically mean bad src
      $scope.playerAction("play")

    # playback controls
    $scope.playerAction = (action) ->
      unless $scope.isPlayingPlaylist()
        # TODO alert some shit
        initializePlayer()
      playlist = $scope.playlist.playlist_songs
      # pressing pause
      if action == "pause"
        Player.pause()
        $scope.player.state = 'paused'
      # if paused and pressing play
      else if $scope.player.state == 'paused' && action == "play"
        Player.play()
        $scope.player.state = 'playing'
      # if pressing play and empty playlist
      else if !playlist.length
        Player.stop()
        initializePlayer()
      # if pressing play and non-empty playlist
      else
        song = _.max playlist, (s) ->
          s.vote_count
        $scope.player.currentSong = song
        Playlist.getMediaURL($scope.playlistId, song.id).then (res) =>
          song.media_url = res.data.url
          Player.play(song)
          $scope.player.state = 'playing'
          Playlist.songPlayed($scope.playlistId, song.id)
        $scope.playlist.playlist_songs = _.without(playlist, song)

    initializePlayer = ->
      $scope.player.currentSong = undefined
      $scope.player.state = undefined
      Player.playlistId = $scope.playlistId
      $scope.$apply() unless $scope.$$phase

    $scope.isPlayingPlaylist = ->
      Player.playlistId == $scope.playlistId

    ##
    # Seekbar
    audio = $scope.player.audio

    $scope.$on "audioDurationchange", ->
      setupSeekbar()
    $scope.$on "audioTimeupdate", ->
      updateUI()

    seekbar = $('.seekbar')[0]
    seekbar.value = 0
    seekbar.onchange = ->
      seekAudio()
    setupSeekbar = ->
      seekbar.min = audio.startTime
      seekbar.max = audio.startTime + audio.duration
    updateUI = ->
      try lastBuffered = audio.buffered.end(audio.buffered.length-1)
      seekbar.min = audio.startTime
      seekbar.max = lastBuffered
      seekbar.value = audio.currentTime
    seekAudio = ->
      audio.currentTime = seekbar.value
]
