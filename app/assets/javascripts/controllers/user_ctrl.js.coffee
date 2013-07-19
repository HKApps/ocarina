ocarina.controller 'UserCtrl', [ '$scope', '$http', '$location',
  ($scope, $http, $location) ->
    $http.get("/users/1.json").then (response) =>
      $scope.user = response.data
]
