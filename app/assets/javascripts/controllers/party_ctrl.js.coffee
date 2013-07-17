App.controller 'PartyCtrl', ['$scope', '$http', '$route',
  ($scope, $http, $route) ->
    partyId = $route.current.params.partyId
    $http.get("/parties/#{partyId}.json").then (response) =>
      $scope.party = response.data
]
