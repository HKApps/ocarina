ocarina.controller 'ProfileCtrl', ['User', '$http', '$scope', '$route',
  (User, $http, $scope, $route) ->
    User.get($route.current.params.userId).then (u) =>
      # TODO change to user
      $scope.user = u
]
