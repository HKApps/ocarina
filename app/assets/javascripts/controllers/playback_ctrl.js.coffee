ocarina.controller 'PlaybackCtrl', ['$scope', '$http', 'Player',
  ($scope, $http, Player) ->
    $scope.player = Player
    audio = $scope.player.audio

    ##
    # Audo Playback
    $scope.$on "audioEnded", ->
      $scope.playerAction("play")

    $scope.playerAction = (action) ->
      playlist = $scope.playlist.playlist_songs
      if Player.paused && action != "skip"
        Player.play()
      else
        return unless playlist.length
        song = _.max playlist, (s) ->
          s.vote_count

        $http.get("/api/playlists/#{$scope.playlist.id}/playlist_songs/#{song.id}/media_url.json").then (res) =>
          song.media_url = res.data.url
          Player.play(song)
          # TODO mark song as played

        $scope.playlist.playlist_songs = _.without(playlist, song)

    ##
    # Seekbar
    audio.addEventListener "durationchange", (->
      setupSeekbar()
    ), false
    audio.addEventListener "timeupdate", (->
      updateUI()
    ), false

    seekbar = $('.seekbar')[0]
    seekbar.value = 0
    seekbar.onchange = ->
      seekAudio()
    setupSeekbar = ->
      seekbar.min = audio.startTime
      seekbar.max = audio.startTime + audio.duration
    updateUI = ->
      lastBuffered = audio.buffered.end(audio.buffered.length-1)
      seekbar.min = audio.startTime
      seekbar.max = lastBuffered
      seekbar.value = audio.currentTime
    seekAudio = ->
      audio.currentTime = seekbar.value
]
