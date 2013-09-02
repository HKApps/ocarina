ocarina.controller 'NavCtrl', [ '$rootScope', '$scope', '$location', 'Playlist',
  ($rootScope, $scope, $location, Playlist) ->

    $scope.$on('$routeChangeStart', (next, current) ->
      window.scrollTo(0, 1)) if $rootScope.isMobilized

    $scope.collapseNav = ->
      return if $('.navbar-collapse').hasClass('collapse')
      $('.navbar-collapse').collapse('hide') if $(window).width() <= 768

    $scope.openNav = ->
      $('.navbar-collapse').collapse('show')

    $scope.toggleSearch = ->
      $scope.showSearch = !$scope.showSearch

    $scope.$on "showSearch", ->
      if $rootScope.isMobilized
        $scope.openNav()
      else
        $scope.toggleSearch()

    $scope.logout = ->
      window.location.replace("/logout")

    $scope.selectedPlaylist = undefined

    $scope.updatePlaylists = ->
      Playlist.getIndex().then (res) =>
        $scope.playlists = res.data

    $scope.goToPlaylist = (playlist) ->
      return unless playlist.id
      $scope.collapseNav()
      $location.path("/playlists/#{playlist.id}")
      $scope.selectedPlaylist = undefined
]
