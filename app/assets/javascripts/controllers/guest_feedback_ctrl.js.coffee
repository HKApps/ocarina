ocarina.controller 'GuestFeedbackCtrl', ['$scope', '$http', 'Playlist'
  ($scope, $http, Playlist) ->
    $scope.toggleSongSaved = (song) ->
      if $scope.songSaved(song.id)
        song = $scope.songSaved(song.id)
        unsaveSong(song)
      else
        saveSong(song)

    saveSong = (song) ->
      $http.post('/api/saved_songs.json',
        user_id: $scope.currentUser.id
        song: song
      ).then (res) =>
        $scope.currentUser.favorites.push res.data

    unsaveSong = (song) ->
      $http.delete("/api/saved_songs/#{song.id}.json",
        params: { user_id: $scope.currentUser.id }
      )
      $scope.currentUser.favorites = _.without($scope.currentUser.favorites, song)

    $scope.songSaved = (id) ->
      _.findWhere($scope.currentUser.favorites, {playlist_song_id: id})

    $scope.skipSongVote = (song) ->
      Playlist.skipSongVote(
        $scope.currentUser.id,
        $scope.playlistId,
        song.id
      )
]
