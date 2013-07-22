ocarina.controller 'UserCtrl', [ '$scope', '$http', '$location',
  ($scope, $http, $location) ->
    $http.get("/api/current_user.json").then (response) =>
      $scope.user = response.data
]
