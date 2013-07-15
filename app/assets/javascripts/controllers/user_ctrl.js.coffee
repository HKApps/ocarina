App.controller 'UserCtrl', [ '$scope', '$http', '$location',
  ($scope, $http, $location) ->
    $http.get("users/1.json").then (response) =>
      $scope.user = response.data

    $scope.partyURL = (id) ->
      # TODO use location.host()
      root = document.location.origin
      "#{root}/parties/#{id}"
]
