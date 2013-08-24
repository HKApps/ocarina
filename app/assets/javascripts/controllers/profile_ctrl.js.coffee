ocarina.controller 'ProfileCtrl', ['$rootScope', '$scope', '$http', '$location', 'Playlist',
  ($rootScope, $scope, $http, $location, Playlist) ->

    $scope.createPlaylist = () ->
      playlist = new Playlist()
      playlist.name = $scope.newPlaylist.name
      playlist.location = $scope.newPlaylist.location
      playlist.private = $scope.newPlaylist.private
      playlist.password = $scope.newPlaylist.password if playlist.private
      playlist.create().then (res) =>
        $location.path("/playlists/#{res.data.id}")
        $scope.user.playlists.push(res.data)
      $scope.closeCreatePlaylistModal()
      resetPlaylistForm()

    $scope.getFbEvents = ->
      $http.get("https://graph.facebook.com/me/events?fields=name,location,venue,privacy&type=attending&access_token=#{$scope.user.facebook_token}").then (res) =>
        $scope.fbEvents = res.data.data

    $scope.hideFbEvents = ->
      $scope.fbEvents = undefined

    $scope.selectFbEvent = (event) ->
      $scope.selectedFbEvent = if event == $scope.selectedFbEvent then undefined else event

    $scope.createPlaylistFromFbEvent = ->
      fbEvent = $scope.selectedFbEvent
      playlist = new Playlist()
      playlist.name = fbEvent.name
      playlist.location = fbEvent.location
      playlist.start_time = fbEvent.start_time
      playlist.venue = fbEvent.venue
      playlist.facebook_id = fbEvent.id
      playlist.private = if fbEvent.privacy == "OPEN" then false else true
      playlist.create().then (res) =>
        $location.path("/playlists/#{res.data.id}")
        $scope.user.playlists.push(res.data)
      $scope.closeCreatePlaylistModal()
      resetPlaylistForm()

    resetPlaylistForm = ->
      $scope.newPlaylist = undefined

    $scope.openCreatePlaylistModal = ->
      $scope.shouldBeOpen = true

    $scope.closeCreatePlaylistModal = ->
      $scope.shouldBeOpen = false

    $scope.modalOpts = { backdropFade:true, dialogFade:true }

    $scope.showSearch = ->
      $rootScope.$broadcast("showSearch")
]
