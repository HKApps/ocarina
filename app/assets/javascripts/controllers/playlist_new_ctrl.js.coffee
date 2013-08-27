ocarina.controller 'PlaylistNewCtrl', ['$rootScope', '$scope', 'Facebook', '$location', 'Playlist',
  ($rootScope, $scope, Facebook, $location, Playlist) ->

    $scope.createPlaylist = () ->
      playlist = new Playlist()
      playlist.name = $scope.newPlaylist.name
      playlist.location = $scope.newPlaylist.location
      playlist.private = $scope.newPlaylist.private
      playlist.password = $scope.newPlaylist.password if playlist.private
      playlist.create().then (res) =>
        $location.path("/playlists/#{res.data.id}")
        $scope.currentUser.playlists.push(res.data)
      resetPlaylistForm()

    $scope.getFbEvents = ->
      Facebook.getEvents($scope.currentUser.facebook_token).then (res) =>
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
      # TODO change this once we have a way of setting passwords for fb events
      playlist.private = false
      # playlist.private = if fbEvent.privacy == "OPEN" then false else true
      playlist.create().then (res) =>
        $location.path("/playlists/#{res.data.id}")
        $scope.currentUser.playlists.push(res.data)
        Facebook.postOnEvent($scope.currentUser.facebook_token, fbEvent.id, "test")
      resetPlaylistForm()

    resetPlaylistForm = ->
      $scope.newPlaylist = undefined
      $scope.hideFbEvents()
]
