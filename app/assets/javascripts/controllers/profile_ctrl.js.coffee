ocarina.controller 'ProfileCtrl', ['User', '$scope', '$route',
  (User, $scope, $route) ->
    User.get($route.current.params.userId).then (u) =>
      # TODO change to user
      $scope.user = u
]
