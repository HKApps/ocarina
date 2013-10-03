describe 'PlaylistShowCtrl', ->
  controller = null
  httpBackend = null
  playlist = null
  scope = null
  route = null
  pusher = null
  location = null

  beforeEach module 'ocarina'
  beforeEach inject ($controller, $httpBackend, Playlist, $route, $location, $rootScope) ->
    controller = $controller
    httpBackend = $httpBackend
    location = $location
    scope = $rootScope.$new()
    scope.currentUser =
      id: 2
    playlist = Playlist
    route = $route
    route.current =
      params:
        playlistId: "12345"
    pusher =
      subscribe: ->
        bind: ->
          true

    # requests on load
    httpBackend.expectGET("/api/playlists/12345.json?user_id=2").respond(
      id: "12345"
      guests:
        [{ id: 1 }]
      owner_id: 3 )

  afterEach ->
    httpBackend.verifyNoOutstandingExpectation()

  it 'gets a playlist and current song on load', ->
    controller 'PlaylistShowCtrl',
      Playlist: playlist
      $scope: scope
      $route: route
      Pusher: pusher

  it 'adds a user to playlist on load', ->
    httpBackend.expectPOST("/api/playlists/12345/join").respond(201)
    httpBackend.expectGET("/api/playlists/12345/current_song_request.json?user_id=2").respond(200)
    httpBackend.expectGET("/partials/playlists/show.html").respond(200)

    controller 'PlaylistShowCtrl',
      Playlist: playlist
      $scope: scope
      $route: route
      Pusher: pusher

    scope.playlist =
      id: "12345"
      guests:
        [{ id: 1 }]
      owner_id: 3

    scope.currentUser = { id: 2, playlists_as_guest: [] }
    expect(scope.isMember(scope.currentUser)).toNotEqual scope.currentUser

    location.path("/playlists/12345")
    httpBackend.flush()
    expect(scope.isMember(scope.currentUser.id)).toEqual scope.currentUser

  it 'does not add a user if they are the host or a member', ->
    httpBackend.expectGET("/api/playlists/12345/current_song_request.json?user_id=1").respond(200)
    httpBackend.expectGET("/partials/playlists/show.html").respond(200)

    controller 'PlaylistShowCtrl',
      Playlist: playlist
      $scope: scope
      $route: route
      Pusher: pusher

    scope.playlist =
      id: "12345"
      guests:
        [{ id: 1 }]
      owner_id: 3

    length = scope.playlist.guests.length

    scope.currentUser = { id: 1 }
    location.path("/playlists/12345")
    httpBackend.flush()
    expect(scope.playlist.guests.length).toEqual length

    scope.currentUser = { id: 3 }
    scope.joinPlaylist(12345)
    expect(scope.playlist.guests.length).toEqual length

  it 'can tell if user is a member', ->
    controller 'PlaylistShowCtrl',
      Playlist: playlist
      $scope: scope
      $route: route
      Pusher: pusher

    scope.playlist =
      guests:
        [{ id: 1 }]
      owner_id: 3

    expect(scope.isMember(1)).toEqual { id: 1 }
    expect(scope.isMember(3)).toEqual true
    expect(scope.isMember(2)).toNotEqual true

  it 'can vote on songs', ->
    httpBackend.expectPOST("/api/playlists/12345/playlist_songs/1/upvote").respond(200)
    httpBackend.expectPOST("/api/playlists/12345/playlist_songs/1/downvote").respond(200)

    controller 'PlaylistShowCtrl',
      Playlist: playlist
      $scope: scope
      $route: route
      Pusher: pusher

    scope.playlist =
      playlist_songs: [
        { id: 1, vote_count: 0, current_user_vote_decision: 0 }
      ]

    song = scope.playlist.playlist_songs[0]

    expect(song.vote_count).toEqual 0
    expect(song.current_user_vote_decision).toEqual 0

    scope.upvoteSong(song)
    expect(song.vote_count).toEqual 1
    expect(song.current_user_vote_decision).toEqual 1

    scope.downvoteSong(song)
    expect(song.vote_count).toEqual 0
    expect(song.current_user_vote_decision).toEqual 0

  it 'cannot vote past current user vote decision', ->
    controller 'PlaylistShowCtrl',
      Playlist: playlist
      $scope: scope
      $route: route
      Pusher: pusher

    scope.playlist =
      playlist_songs: [
        { id: 1, vote_count: 3, current_user_vote_decision: 1 }
        { id: 2, vote_count: 0, current_user_vote_decision: -1 }
      ]

    upvoted_song = scope.playlist.playlist_songs[0]
    downvoted_song = scope.playlist.playlist_songs[1]

    expect(upvoted_song.vote_count).toEqual 3
    expect(upvoted_song.current_user_vote_decision).toEqual 1

    scope.upvoteSong(upvoted_song)
    expect(upvoted_song.vote_count).toEqual 3
    expect(upvoted_song.current_user_vote_decision).toEqual 1

    expect(downvoted_song.vote_count).toEqual 0
    expect(downvoted_song.current_user_vote_decision).toEqual -1

    scope.downvoteSong(downvoted_song)
    expect(downvoted_song.vote_count).toEqual 0
    expect(downvoted_song.current_user_vote_decision).toEqual -1
