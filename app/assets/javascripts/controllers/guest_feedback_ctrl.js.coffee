ocarina.controller 'GuestFeedbackCtrl', ['$scope', 'Playlist', 'SavedSong'
  ($scope, Playlist, SavedSong) ->
    $scope.toggleSongSaved = (song) ->
      if $scope.songSaved(song.id)
        song = $scope.songSaved(song.id)
        unsaveSong(song)
      else
        saveSong(song)

    saveSong = (song) ->
      SavedSong.create($scope.currentUser.id, song).then (res) =>
        $scope.currentUser.favorites.push res.data

    unsaveSong = (song) ->
      SavedSong.delete($scope.currentUser.id, song.id)
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
