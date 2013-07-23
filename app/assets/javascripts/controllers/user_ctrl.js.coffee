ocarina.controller 'UserCtrl', ['User', '$scope',
  (User, $scope) ->
    User.getCurrentUser().then (u) =>
      $scope.user = u
]
