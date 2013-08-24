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
        $scope.user.saved_songs.push res.data

    unsaveSong = (song) ->
      $http.delete("/api/saved_songs/#{song.id}.json")
      $scope.user.saved_songs = _.without($scope.user.saved_songs, song)

    $scope.songSaved = (id) ->
      _.findWhere($scope.user.saved_songs, {playlist_song_id: id})
]
