App.controller 'UserCtrl', [ '$scope', '$http', '$location',
  ($scope, $http, $location) ->
    $http.get("users/1.json").then (response) =>
      $scope.user = response.data

    $scope.partyURL = (id) ->
      "/parties/#{id}"

    $scope.createParty = ->
      # send $scope.newParty
      $scope.newParty = {}

]
