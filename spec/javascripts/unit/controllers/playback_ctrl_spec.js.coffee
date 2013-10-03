describe 'PlaybackCtrl', ->
  controller = null
  httpBackend = null
  scope = null
  http = null
  route = null
  playlist = null
  player = null
  facebook = null

  beforeEach module 'ocarina'
  beforeEach inject ($controller, $httpBackend, $rootScope, $http, $route, Playlist, Player, Facebook) ->
    httpBackend = $httpBackend
    rootScope = $rootScope
    scope = $rootScope.$new()
    scope.playlist =
      facebook_id: "54321"
    scope.currentUser =
      facebook_token: "token"
    http = $http
    playlist = Playlist
    player = Player
    facebook = Facebook
    route = $route
    route.current =
      params:
        playlistId: "12345"

    $controller 'PlaybackCtrl',
      $scope: scope
      $rootScope: rootScope
      $http: http
      $route: route
      Playlist: playlist
      Player: player
      Facebook: facebook

  afterEach ->
    httpBackend.verifyNoOutstandingExpectation()

  it "can pause", ->
    expect(player.state).toNotEqual "paused"
    scope.playerPause()
    expect(player.state).toEqual "paused"

  it "can get the most upvoted song", ->
    scope.playlist =
      playlist_songs:[
        { id: 1, vote_count: 1},
        { id: 2, vote_count: 3},
        { id: 2, vote_count: 2}
      ]

    song = scope.getNextSong(scope.playlist.playlist_songs)
    expect(song.vote_count).toEqual 3

    scope.playlist =
      playlist_songs:[
        { id: 1, vote_count: -1},
        { id: 2, vote_count: -3},
        { id: 3, vote_count: -2}
      ]

    song = scope.getNextSong(scope.playlist.playlist_songs)
    expect(song.vote_count).toEqual -1

  it "can get a random played song that is different from current songs", ->
    scope.playlist =
      playlist_songs:[
        { id: 1, vote_count: 1, media_url: "path1" },
        { id: 2, vote_count: 3, media_url: "path2" },
        { id: 3, vote_count: 2, media_url: "path3" }
      ]

    song1 = scope.getRandomPlayedSong(scope.playlist.playlist_songs)
    scope.playlist.currentSong = song1
    song2 = scope.getRandomPlayedSong(scope.playlist.playlist_songs)

    expect(song1).toNotEqual song2

  it "can play the next song", ->
    # TODO

  it "formats time properly", ->
    # TODO
