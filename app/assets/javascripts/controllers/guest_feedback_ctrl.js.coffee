ocarina.controller 'GuestFeedbackCtrl', ['$scope', '$http',
  ($scope, $http) ->
    #TODO make api call to get current song
    # $scope.playlist.currentSong = undefined

    $scope.saveSong = (song) ->
      $http.post('/api/saved_songs.json', song).then (res) =>
        # mark song saved

      # TODO send to API
      # TODO add to user.saved_songs
]
