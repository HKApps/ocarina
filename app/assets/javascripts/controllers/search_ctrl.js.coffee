ocarina.controller "SearchCtrl", ['$scope', '$http', '$location',
  ($scope, $http, $location) ->
    $scope.selectedPlaylist = undefined
    $http.get("/api/playlists.json").then (res) =>
      $scope.playlists = res.data

    $scope.joinPlaylist = (playlist) ->
      unless playlist.owner_id == $scope.user.id or _.findWhere($scope.user.playlists_as_guest, { id: playlist.id })
        $http.post("/api/playlists/#{playlist.id}/join").then (res) =>
          if res.status == 201
            $scope.user.playlists_as_guest.push(res.data)
      $location.path("/playlists/#{playlist.id}")
]
