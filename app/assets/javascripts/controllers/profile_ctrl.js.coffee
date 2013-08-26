ocarina.controller 'ProfileCtrl', ['User', '$scope', '$route',
  (User, $scope, $route) ->
    User.get($route.current.params.userId).then (u) =>
      $scope.user = u
]
