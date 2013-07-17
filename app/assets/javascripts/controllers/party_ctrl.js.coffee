App.controller 'PartyCtrl', ['$scope', '$http', '$route',
  ($scope, $http, $route) ->
    $scope.partyId = $route.current.params.partyId

    # TODO get party info from server using partyID
]
