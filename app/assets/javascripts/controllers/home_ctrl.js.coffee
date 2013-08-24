ocarina.controller 'HomeCtrl', ['$rootScope', '$scope',
  ($rootScope, $scope) ->
    $scope.showSearch = ->
      $rootScope.$broadcast("showSearch")
]
