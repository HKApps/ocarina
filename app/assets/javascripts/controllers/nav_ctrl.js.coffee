ocarina.controller 'NavCtrl', [ '$rootScope', '$scope',
  ($rootScope, $scope) ->
    $scope.isCollapsed = false

    $scope.openDbSongsModal = ->
      $rootScope.$broadcast("openDbSongsModal")

    $scope.logout = ->
      window.location.replace("/logout")
]
