App.controller 'UserCtrl', [ '$scope', '$http', '$location',
  ($scope, $http, $location) ->
    $http.get("/users/1.json").then (response) =>
      $scope.user = response.data

    $scope.createParty = ->
      # TODO send $scope.newParty
      $scope.newParty = {}
]
