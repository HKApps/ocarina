App.controller 'UserCtrl', [ '$scope', '$http', '$location',
  ($scope, $http, $location) ->
    $http.get("/users/1.json").then (response) =>
      $scope.user = response.data

      if $scope.user.dropbox_authenticated
        $http.get("/dropbox.json").then (response) =>
          $scope.user.dropboxSongs = response.data.contents

    $scope.createParty = ->
      # TODO send $scope.newParty
      $scope.newParty = {}
]
