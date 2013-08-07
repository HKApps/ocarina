ocarina.controller 'NavCtrl', [ '$rootScope', '$scope', '$http', '$location',
  ($rootScope, $scope, $http, $location) ->

    $scope.$on('$routeChangeStart', (next, current) ->
      window.scrollTo(0, 1)) if $rootScope.isMobilized

    $scope.collapseNav = ->
      $('.nav-collapse').collapse('hide')

    $scope.openDbSongsModal = ->
      $rootScope.$broadcast("openDbSongsModal")

    $scope.logout = ->
      window.location.replace("/logout")

    $scope.selectedPlaylist = undefined

    $http.get("/api/playlists.json").then (res) =>
      $scope.playlists = res.data

    $scope.joinPlaylist = (playlist) ->
      return unless playlist.id
      unless playlist.owner_id == $scope.user.id or _.findWhere($scope.user.playlists_as_guest, { id: playlist.id })
        $http.post("/api/playlists/#{playlist.id}/join").then (res) =>
          if res.status == 201
            $scope.user.playlists_as_guest.push(res.data)
      $location.path("/playlists/#{playlist.id}")
      $scope.selectedPlaylist = undefined
]
