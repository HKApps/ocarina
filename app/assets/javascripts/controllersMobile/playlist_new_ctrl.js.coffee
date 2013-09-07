ocarina.controller 'PlaylistNewCtrl', ['$scope', 'Playlist', '$location',
  ($scope, Playlist, $location) ->
    $scope.getLocation = ->
      if navigator.geolocation
        navigator.geolocation.getCurrentPosition($scope.showPosition)
      else
        x.innerHTML="Geolocation is not supported by this browser."

    $scope.showPosition = (position) ->
      $scope.newPlaylist =
        settings:
          continuous_play: true
        venue:
          latitude: position.coords.latitude
          longitude: position.coords.longitude

    $scope.createPlaylist = () ->
      playlist = new Playlist()
      playlist.name = $scope.newPlaylist.name
      playlist.venue = $scope.newPlaylist.venue
      if $scope.newPlaylist.password
        playlist.private = true
        playlist.password = $scope.newPlaylist.password
      playlist.create().then (res) =>
        $location.path("/playlists/#{res.data.id}")
        $scope.currentUser.playlists.push(res.data)

    $scope.getLocation()
]
