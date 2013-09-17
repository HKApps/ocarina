ocarina.controller 'GuestFeedbackCtrl', ['$scope', '$http',
  ($scope, $http) ->
    $scope.toggleSongSaved = (song) ->
      if $scope.songSaved(song.id)
        song = $scope.songSaved(song.id)
        unsaveSong(song)
      else
        saveSong(song)

    saveSong = (song) ->
      $http.post('/api/saved_songs.json', song).then (res) =>
        $scope.currentUser.favorites.push res.data

    unsaveSong = (song) ->
      $http.delete("/api/saved_songs/#{song.id}.json")
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
