ocarina.controller 'PlaybackCtrl', ['$scope', '$http', 'Player',
  ($scope, $http, Player) ->
    $scope.player = Player

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

        $http.get("/api/playlists/#{playlist.id}/playlist_songs/#{song.id}/media_url.json").then (res) =>
          song.media_url = res.data.url
          Player.play(song)
          # TODO mark song as played

        $scope.playlist.playlist_songs = _.without(playlist, song)
]
