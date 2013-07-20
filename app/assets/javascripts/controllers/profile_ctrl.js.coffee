ocarina.controller 'ProfileCtrl', ['$scope', '$http', '$route', '$location',
  ($scope, $http, $route, $location) ->
    $scope.createParty = () ->
      future = $http.post "/parties.json",
          name: $scope.newParty.name

      future.then (response) =>
        if response.status == 201
          $scope.user.parties.push(response.data)
          $location.path("/parties/#{response.data.id}")
        # TODO else render error message

      $scope.newParty.name = ''
]
