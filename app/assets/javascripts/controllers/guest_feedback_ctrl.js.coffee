ocarina.controller 'GuestFeedbackCtrl', ['$scope',
  ($scope) ->
    #TODO make api call to get current song
    $scope.playlist.currentSong = undefined

    $scope.saveSong = (song) ->
      # TODO send to API
      # TODO add to user.saved_songs

    $scope.skipSong = (song) ->
      # TODO send to API
      # TODO add to playlist_songs.votes_to_skip
]
