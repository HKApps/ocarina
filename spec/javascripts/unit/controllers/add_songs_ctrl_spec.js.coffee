describe 'AddSongsCtrl', ->
  controller = null
  httpBackend = null
  playlist = null
  scope = null

  beforeEach module 'ocarina'
  beforeEach inject ($controller, $httpBackend, $rootScope, Playlist) ->
    httpBackend = $httpBackend
    scope = $rootScope.$new()
    playlist = Playlist
    $controller 'AddSongsCtrl',
      $scope: scope
      Playlist: playlist

    scope.playlist =
      playlist_songs: [
        { id: 1, song_id: 1, provider: "Dropbox", path: "path1" }
        { id: 2, song_id: 2, provider: "Soundcloud", path: "path2" }
      ]
      played_playlist_songs: [
        { id: 3, song_id: 3, provider: "Dropbox", path: "path3" }
        { id: 4, song_id: 4, provider: "Soundcloud", path: "path4" }
      ]

  afterEach ->
    httpBackend.verifyNoOutstandingExpectation()

  it 'can tell if soundcloud song is in the playlist', ->
    scope.provider = 'Soundcloud'

    inPlaylist =
      id: 2
      song_id: 2
      uri: "path2"

    playedInPlaylist =
      id: 4
      song_id: 4
      uri: "path4"

    notInPlaylist =
      id: 5
      song_id: 5
      uri: "path5"

    expect(scope.songInPlaylist(notInPlaylist)).toEqual undefined
    expect(scope.songInPlaylist(inPlaylist)).toEqual scope.playlist.playlist_songs[1]
    expect(scope.songInPlaylist(playedInPlaylist)).toEqual scope.playlist.played_playlist_songs[1]

  it 'can tell if dropbox song is in the playlist', ->
    scope.provider = 'Dropbox'

    inPlaylist = 1

    playedInPlaylist = 3

    notInPlaylist = 5

    expect(scope.songInPlaylist(notInPlaylist)).toEqual undefined
    expect(scope.songInPlaylist(inPlaylist)).toEqual scope.playlist.playlist_songs[0]
    expect(scope.songInPlaylist(playedInPlaylist)).toEqual scope.playlist.played_playlist_songs[0]

  it 'can tell if song is selected', ->
    scope.selectedSongs =
      dropbox: [5, 6]
      soundcloud: [
        { name: "spaceman" }
      ]

    dbSelected = scope.selectedSongs.dropbox[0]
    dbUnselected = 7

    expect(scope.isSongSelected("dropbox", dbSelected)).toEqual true
    expect(scope.isSongSelected("dropbox", dbUnselected)).toEqual false

    scSelected = scope.selectedSongs.soundcloud[0]
    scUnselected = { name: "levels" }

    expect(scope.isSongSelected("soundcloud", scSelected)).toEqual true
    expect(scope.isSongSelected("soundcloud", scUnselected)).toEqual false

  it 'can toggle song selected', ->
    song = { name: "hello" }

    expect(scope.isSongSelected(song)).toEqual false

    scope.toggleSongSelected("soundcloud", song)
    expect(scope.isSongSelected("soundcloud", song)).toEqual true

    scope.toggleSongSelected("soundcloud", song)
    expect(scope.isSongSelected("soundcloud", song)).toEqual false

  it 'can clear selected songs', ->
    scope.selectedSongs =
      dropbox: [5, 6]
      soundcloud: [
        { name: "spaceman" }
      ]

    scope.clearSelectedSongs()
    expect(scope.selectedSongs).toEqual { dropbox: [], soundcloud: [] }
