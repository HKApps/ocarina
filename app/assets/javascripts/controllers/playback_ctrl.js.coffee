ocarina.controller 'PlaybackCtrl', ['$scope', '$rootScope', '$route', 'Playlist', 'Player', 'Facebook',
  ($scope, $rootScope, $route, Playlist, Player, Facebook) ->
    $scope.playlistId = $route.current.params.playlistId

    ##
    # continuous play setup
    contPlayPosition = 0
    nextContPlaySong = undefined

    if $scope.playlist.facebook_id
      Facebook.getEventsFavoriteArtists(
        $scope.currentUser.facebook_token,
        $scope.playlist.facebook_id
      ).then (res) =>
        $scope.contPlaylist = res
        $scope.setContPlaySong()
    else
      facebook_ids = $scope.playlist.host.facebook_id
      _.each $scope.playlist.guests, (guest) ->
        facebook_ids += ", #{guest.facebook_id}"
      Facebook.getPartiesFavoriteArtists(
        $scope.currentUser.facebook_token,
        facebook_ids
      ).then (res) =>
        $scope.contPlaylist = res
        $scope.setContPlaySong()

    $scope.setContPlaySong= ->
      contPlayPosition = 0 unless $scope.contPlaylist[contPlayPosition]
      artist = $scope.contPlaylist[contPlayPosition]
      SC.get '/tracks',
        q: artist
        order: "hotness"
        duration:
          to: 600000
        limit: 10
      , (tracks, error) ->
        if error
          $scope.setContPlaySong()
        else
          Playlist.addSongs(
            $scope.currentUser.id,
            $scope.playlistId,
            soundcloud: [tracks[0]]
            dropbox: []
          ).then (res) =>
            nextContPlaySong = res.data[0]
            Playlist.songPlayed(
              $scope.currentUser.id,
              $scope.playlistId,
              nextContPlaySong.id
            )
          contPlayPosition++

    ##
    # audo playback
    $scope.player = Player

    ##
    # event listeners
    $scope.$on "audioEnded", ->
      if $scope.isPlayingPlaylist()
        $scope.playerAction("play")
      else
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

    $scope.playerAction = (action) ->
      initializePlayer() unless $scope.isPlayingPlaylist()
      # makes playback work in safari mobile
      if $rootScope.isiOS && Player.state == undefined
        # TODO check what happens if first action is pause on mobile
        Player.play()
      # if paused and pressing play
      if Player.state == 'paused' && action == "play"
        Player.play()
      # if play or skip and empty playlist
      else if !$scope.playlist.playlist_songs.length
        playNextSong($scope.playlist, true)
      # if play or skip and non-empty playlist
      else
        playNextSong($scope.playlist)

    playbackEnded = ->
      initializePlayer()
      Playlist.playbackEnded($scope.playlistId)

    $scope.getNextSong = (songs) ->
      song = _.max songs, (s) ->
        s.vote_count

    $scope.getRandomPlayedSong = (songs) ->
      random = _.random(songs.length-1)
      song = songs[random]
      try if song.media_url == $scope.playlist.currentSong.media_url && songs.length != 1
        random = if random >= 0 then random-1 else random+1
        song = songs[random]
      song

    playNextSong = (playlist, contPlay) ->
      if contPlay
        song = nextContPlaySong
        $scope.setContPlaySong()
      else
        song = $scope.getNextSong(playlist.playlist_songs)
      playlist.currentSong = song
      Player.currentSong = song
      Player.play(song)
      unless _.findWhere(playlist.played_playlist_songs, { media_url: song.media_url })
        Playlist.songPlayed(
          $scope.currentUser.id,
          $scope.playlistId,
          song.id
        )
        playlist.played_playlist_songs.push(song)
      $scope.playlist.playlist_songs = _.without(playlist.playlist_songs, song)

    initializePlayer = ->
      Player.stop($scope.playlistId)
      $scope.playlist.currentSong = undefined
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
      # in-case leaving and coming back to playlist
      $('.duration').text(" / " + timeFormat(audio.duration)) if audio.duration
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

    ##
    # set current song if owner returning to playlist
    if $scope.isPlayingPlaylist() && $scope.playlist.owner_id == $scope.currentUser.id
      $scope.playlist.currentSong = Player.currentSong
]
