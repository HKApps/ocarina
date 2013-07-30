ocarina.controller 'NavCtrl', [ '$rootScope', '$scope',
  ($rootScope, $scope) ->
    $scope.openDbSongsModal = ->
      $rootScope.$broadcast("openDbSongsModal")

    $scope.logout = ->
      window.location.replace("/logout")
]
