ocarina.controller 'SearchCtrl', [ '$rootScope', '$scope', '$http', '$location',
  ($rootScope, $scope, $http, $location) ->
    $scope.users = []
    $scope.playlists = []

    $scope.search = (term) ->
      $http.get("/api/search?query=#{encodeURIComponent(term)}&format=json").then (res) ->
        $scope.users = res.data.users
        $scope.playlists = res.data.playlists
        $scope.searchResults = $scope.users.concat($scope.playlists)

    $scope.select = (item) ->
      # TODO(mn) - Find a better way to navigate to an item's page
      if item.owner_id
        $location.path("/playlists/#{item.id}")
      else
        $location.path("/#{item.id}")

    $scope.hasPlaylists = ->
      $scope.playlists.length > 0

    $scope.hasUsers = ->
      $scope.users.length > 0
]
