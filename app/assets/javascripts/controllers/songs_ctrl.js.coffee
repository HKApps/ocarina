ocarina.controller 'SongsCtrl', [ '$scope', '$http', '$location',
  ($scope, $http, $location) ->
    # TODO move this to /users/:id/songs.json
    $http.get("/dropbox.json").then (response) =>
      $scope.songs = response.data.contents
]
