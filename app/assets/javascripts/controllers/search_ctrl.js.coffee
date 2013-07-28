ocarina.controller "SearchCtrl", ['$scope', '$http', '$location',
  ($scope, $http, $location) ->
    $scope.selectedPlaylist = undefined
    $http.get("/api/playlists.json").then (res) =>
      $scope.playlists = res.data

    $scope.joinPlaylist = (id) ->
      $http.post("/api/playlists/#{id}/join").then (res) =>
        if res.status == 200
          $scope.user.playlists.push(res.data)
      $location.path("/playlists/#{id}")
]
