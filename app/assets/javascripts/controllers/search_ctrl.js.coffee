ocarina.controller 'SearchCtrl', [ '$rootScope', '$scope', '$http', '$location',
  ($rootScope, $scope, $http, $location) ->
    $scope.users = []
    $scope.playlists = []

    $scope.search = (term) ->
      $http.get("/api/search?query=#{encodeURIComponent(term)}&format=json").then (res) ->
        $scope.users = res.data.users
        $scope.playlists = res.data.playlists

    $scope.select = (item) ->
      console.log(item)

    $scope.hasPlaylists = ->
      $scope.playlists.length > 0

    $scope.hasUsers = ->
      $scope.users.length > 0
]
