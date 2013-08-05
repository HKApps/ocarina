ocarina.controller 'PlaybackCtrl', ['$scope', '$http', 'Player',
  ($scope, $http, Player) ->

    $scope.player = Player
    audio = $scope.player.audio

    ##
    # Audo Playback

    # make sure the player has stopped
    Player.stop()

    # add event listeners
    $scope.$on "audioEnded", ->
      $scope.playerAction("play")
    $scope.$on "audioError", ->
      # because errors typically mean bad src
      $scope.playerAction("play")

    # playback controls
    $scope.playerAction = (action) ->
      playlist = $scope.playlist.playlist_songs
      if Player.paused && action == "play"
        Player.play()
      else if !playlist.length
        Player.stop()
      else
        song = _.max playlist, (s) ->
          s.vote_count
        $http.get("/api/playlists/#{$scope.playlist.id}/playlist_songs/#{song.id}/media_url.json").then (res) =>
          song.media_url = res.data.url
          Player.play(song)
          $http.post("/api/playlists/#{$scope.playlist.id}/playlist_songs/#{song.id}/played")
        $scope.playlist.playlist_songs = _.without(playlist, song)

    ##
    # Seekbar
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
