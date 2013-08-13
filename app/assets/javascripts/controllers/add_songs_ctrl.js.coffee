ocarina.controller 'AddSongsCtrl', ['$scope', 'Playlist',
  ($scope, Playlist) ->
    ##
    # add songs setup
    $scope.provider = "Dropbox"

    $scope.selectedSongs =
      dropbox: []
      soundcloud: []

    $scope.songInPlaylist = (id) ->
      _.findWhere($scope.playlist.playlist_songs, {id: id})

    $scope.isSongSelected = (provider, song) ->
      _.any $scope.selectedSongs[provider], (selectedSong) ->
        selectedSong == song

    $scope.toggleSongSelected = (provider, song) ->
      return if $scope.songInPlaylist(song)
      if $scope.isSongSelected(provider, song)
        $scope.selectedSongs[provider] = _.without($scope.selectedSongs[provider], song)
      else
        $scope.selectedSongs[provider].push(song)

    $scope.addSelectedSongs = ->
      $scope.closeAddSongsModal()
      Playlist.addSongs($scope.playlistId, $scope.selectedSongs).then (res) =>
        _.each res.data, (song) ->
          song.current_user_vote_decision = 0
          $scope.playlist.playlist_songs.push(song)
      $scope.clearSelectedSongs()

    $scope.clearSelectedSongs = ->
      $scope.scFilter = undefined
      $scope.dbFilter = undefined
      $scope.scResults = []
      $scope.selectedSongs =
        dropbox: []
        soundcloud: []

    ##
    # soundcloud search
    $scope.scResults = []
    $scope.searchSc = (query) ->
      if query
        SC.get '/tracks',
          q: query
          order: "hotness"
          duration:
            to: 600000
          limit: 10
        , (tracks) ->
          console.log tracks
          $scope.scResults = tracks
          $scope.$apply()
      else
        $scope.scResults = []
]
