describe 'GuestFeedbackCtrl', ->
  controller = null
  httpBackend = null
  scope = null
  http = null

  beforeEach module 'ocarina'
  beforeEach inject ($controller, $httpBackend, $rootScope, $http) ->
    httpBackend = $httpBackend
    scope = $rootScope.$new()
    http = $http
    $controller 'GuestFeedbackCtrl',
      $scope: scope
      $http: http

    scope.currentUser =
      id: 2
      favorites: [
        { playlist_song_id: 1 }
      ]

  afterEach ->
    httpBackend.verifyNoOutstandingExpectation()

  it 'can toggle song saved', ->
    song = { id: 2 }
    expect(scope.songSaved(song.id)).toEqual undefined

    httpBackend.expectPOST("/api/saved_songs.json").respond({ id: 2, playlist_song_id: 2})
    scope.toggleSongSaved(song)
    httpBackend.flush()
    expect(scope.songSaved(song.id)).toEqual { id: 2,playlist_song_id: 2 }

    httpBackend.expectDELETE("/api/saved_songs/2.json?user_id=2").respond(200)
    scope.toggleSongSaved(song)
    httpBackend.flush()
    expect(scope.songSaved(song.id)).toEqual undefined

  it 'can tell if song is already saved', ->
    savedSong = { id: 1 }
    unsavedSong = { id: 2 }

    expect(scope.songSaved(savedSong.id)).toEqual scope.currentUser.favorites[0]
    expect(scope.songSaved(unsavedSong.id)).toEqual undefined
