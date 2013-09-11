ocarina.controller 'AddSongsCtrl', ['$scope', 'Playlist',
  ($scope, Playlist) ->
    ##
    # add songs setup
    $scope.selectedSongs =
      dropbox: []
      soundcloud: []

    $scope.songInPlaylist = (provider, song) ->
      false
      if provider == "dropbox"
        _.findWhere($scope.playlist.playlist_songs, {song_id: song}) || _.findWhere($scope.playlist.played_playlist_songs, {song_id: song})
      else if provider == "soundcloud"
        _.findWhere($scope.playlist.playlist_songs, {path: song.uri}) || _.findWhere($scope.playlist.played_playlist_songs, {path: song.uri})

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
      $scope.$emit("addingSongs")
      Playlist.addSongs($scope.playlistId, $scope.selectedSongs).then (res) =>
        $scope.$emit("addedSongs")
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
        $scope.inProgress = true
        SC.get '/tracks',
          q: query
          order: "hotness"
          duration:
            to: 600000
          limit: 10
        , (tracks, error) ->
          if error
            $scope.searchSc(query)
          else
            $scope.scResults = tracks
            $scope.inProgress = false
            $scope.$apply()
      else
        $scope.scResults = []
]
