ocarina.controller 'ProfileCtrl', ['$scope', '$http', '$route', '$location',
  ($scope, $http, $route, $location) ->
    $scope.createPlaylist = () ->
      future = $http.post "/playlists.json",
          name: $scope.newPlaylist.name

      future.then (response) =>
        if response.status == 201
          $scope.user.playlists.push(response.data)
          $location.path("/playlists/#{response.data.id}/add_songs")
        # TODO else render error message

      $scope.newPlaylist.name = ''
]
