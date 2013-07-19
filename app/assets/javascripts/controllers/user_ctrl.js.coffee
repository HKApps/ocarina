ocarina.controller 'UserCtrl', [ '$scope', '$http', '$location',
  ($scope, $http, $location) ->
    $http.get("/users/1.json").then (response) =>
      $scope.user = response.data

    $scope.createParty = ->
      future = $http.post "/parties.json",
        name: $scope.newParty.name

      future.then (response) =>
        if response.status == 201
          $scope.user.parties.push(response.data)
        # TODO else render error message

      $scope.newParty = {}
]
