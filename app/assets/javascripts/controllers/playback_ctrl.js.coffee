ocarina.controller 'PlaybackCtrl', ['$scope', '$rootScope', '$http', '$route', 'Playlist', 'Player',
  ($scope, $rootScope, $http, $route, Playlist, Player) ->
    $scope.playlistId = $route.current.params.playlistId

    ##
    # audo playback
    $scope.player = Player

    ##
    # Event listeners
    $scope.$on "audioEnded", ->
      if $scope.isPlayingPlaylist()
        $scope.playerAction("play")
      else
        # TODO maybe get song from playlist_songs?
        initializePlayer()

    $scope.$on "audioError", ->
      # because errors typically mean bad src
      $scope.playerAction("play")

    $scope.$on 'skip-song', (scope, data)->
      return unless data.song_id == $scope.playlist.currentSong.id
      $scope.playerAction('skip')

    ##
    # Functions
    $scope.playerPause = ->
      Player.pause()
      $scope.player.state = 'paused'

    $scope.playerAction = (action) ->
      playlist = $scope.playlist.playlist_songs
      initializePlayer() unless $scope.isPlayingPlaylist()
      # makes playback work in safari mobile
      if $rootScope.isiOS && $scope.player.state == undefined
        Player.play()
      # if paused and pressing play
      if $scope.player.state == 'paused' && action == "play"
        Player.play()
        $scope.player.state = 'playing'
      # if play or skip and empty playlist
      else if !playlist.length
        initializePlayer()
      # if play or skip and non-empty playlist
      else
        getNextSong(playlist)

    getNextSong = (playlist) ->
      song = _.max playlist, (s) ->
        s.vote_count
      playNextSong(playlist, song)

    playNextSong = (playlist, song) ->
      $scope.playlist.currentSong = song
      Player.play(song)
      $scope.player.state = 'playing'
      Playlist.songPlayed($scope.playlistId, song.id)
      $scope.playlist.playlist_songs = _.without(playlist, song)

    initializePlayer = ->
      Player.stop()
      $scope.playlist.currentSong = undefined
      $scope.player.state = undefined
      Player.playlistId = $scope.playlistId
      $scope.$apply() unless $scope.$$phase

    $scope.isPlayingPlaylist = ->
      Player.playlistId == $scope.playlistId

    ##
    # progress bar
    audio = $scope.player.audio

    $scope.$on "audioDurationchange", ->
      # set the duration
      $('.duration').text(" / " + timeFormat(audio.duration))
    $scope.$on "audioTimeupdate", ->
      # set the current time
      $('.current-time').text(timeFormat(audio.currentTime))
      # update progress
      percentage = 100 * audio.currentTime / audio.duration
      setTimebar(percentage)
    $scope.$on "audioProgress", ->
      # update buffer
      try percentage = 100 * audio.buffered.end(0) / audio.duration
      $('.bufferbar').css 'width', percentage + '%'

    setTimebar = (percentage) ->
      $(".timebar").css "width", percentage + "%"

    ##
    # seek updates
    $scope.timeDrag = false
    $scope.updatebar = (x) ->
      progress = $(".progressbar")
      # audio duration / click position
      percentage = 100 * (x - progress.offset().left) / progress.width()
      # make sure it stays within range
      percentage = 100 if percentage > 100
      percentage = 0 if percentage < 0
      #update progress bar and current time
      setTimebar (percentage)
      audio.currentTime = audio.duration * percentage / 100


    timeFormat = (seconds) ->
      if Math.floor(seconds / 60) < 10
        m = "0" + Math.floor(seconds / 60)
      else
        m = Math.floor(seconds / 60)
      if Math.floor(seconds - (m * 60)) < 10
        s= "0" + Math.floor(seconds - (m * 60))
      else
        s= Math.floor(seconds - (m * 60))
      m + ":" + s
]
