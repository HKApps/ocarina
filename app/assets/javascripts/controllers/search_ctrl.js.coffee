ocarina.controller "SearchCtrl", ['$scope', '$http', '$location',
  ($scope, $http, $location) ->
    $scope.selectedPlaylist = undefined
    $http.get("/api/playlists.json").then (res) =>
      $scope.playlists = res.data

    $scope.joinPlaylist = (playlist) ->
      $http.post("/api/playlists/#{playlist.id}/join").then (res) =>
        if res.status == 201
          # TODO change this when server responds properly
          $scope.user.playlists_as_guest.push({
            playlist_id: playlist.id
            playlist_name: playlist.name
          })
      $location.path("/playlists/#{playlist.id}")
]
