ocarina.controller 'ProfileCtrl', ['$rootScope', '$scope',
  ($rootScope, $scope) ->
    $scope.showSearch = ->
      $rootScope.$broadcast("showSearch")
]
