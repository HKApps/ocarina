ocarina.controller 'PlaylistNewCtrl', ['$scope',
  ($scope) ->
    $scope.getLocation = ->
      if navigator.geolocation
        navigator.geolocation.getCurrentPosition($scope.showPosition)
      else
        x.innerHTML="Geolocation is not supported by this browser."

    $scope.showPosition = (position) ->
      $scope.newPlaylist =
        venue:
          latitude: position.coords.latitude
          longitude: position.coords.longitude

    $scope.getLocation()
]
