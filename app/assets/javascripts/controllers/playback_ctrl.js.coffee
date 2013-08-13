ocarina.controller 'PlaybackCtrl', ['$scope', '$rootScope', '$http', '$route', 'Playlist', 'Player',
  ($scope, $rootScope, $http, $route, Playlist, Player) ->
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
      if $rootScope.isiOS && $scope.player.state == undefined
        Player.play()
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
        if song.provider == "dropbox"
          Playlist.getMediaURL($scope.playlistId, song.id).then (res) =>
            song.media_url = res.data.url
            Player.play(song)
            $scope.player.state = 'playing'
            Playlist.songPlayed($scope.playlistId, song.id)
        if song.provider == "soundcloud"
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
      $('.duration').text(timeFormat(audio.duration))
    $scope.$on "audioTimeupdate", ->
      $('.current-time').text(timeFormat(audio.currentTime))
      percentage = 100 * audio.currentTime / audio.duration
      $('.timebar').css('width', "#{percentage}%")
    $scope.$on "audioProgress", ->
      try percentage = 100 * audio.buffered.end(0) / audio.duration
      $('.bufferbar').css('width', "#{percentage}%")

    timeFormat = (seconds) ->
      m = (if Math.floor(seconds / 60) < 10 then "0" + Math.floor(seconds / 60) else Math.floor(seconds / 60))
      s = (if Math.floor(seconds - (m * 60)) < 10 then "0" + Math.floor(seconds - (m * 60)) else Math.floor(seconds - (m * 60)))
      m + ":" + s
]
