ocarina.controller 'NavCtrl', [ '$rootScope', '$scope', '$http', '$location',
  ($rootScope, $scope, $http, $location) ->
    $scope.isCollapsed = false

    $scope.openDbSongsModal = ->
      $rootScope.$broadcast("openDbSongsModal")

    $scope.logout = ->
      window.location.replace("/logout")

    $scope.selectedPlaylist = undefined

    $http.get("/api/playlists.json").then (res) =>
      $scope.playlists = res.data

    $scope.joinPlaylist = (id) ->
      $http.post("/api/playlists/#{id}/join").then (res) =>
        if res.status == 200
          $scope.user.playlists.push(res.data)
      $scope.selectedPlaylist = undefined
      $location.path("/playlists/#{id}")
]
