ocarina.controller 'ProfileCtrl', ['$scope', '$http', '$route',
  ($scope, $http, $route) ->
    $scope.createParty = () ->
      future = $http.post "/parties.json",
          name: $scope.newParty.name

      future.then (response) =>
        if response.status == 201
          $scope.user.parties.push(response.data)
        # TODO else render error message

      $scope.newParty.name = ''
]
