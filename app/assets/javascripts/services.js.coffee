ocarinaServices = angular.module('ocarinaServices', ['ngResource'])

ocarinaServices.factory 'Pusher', ->
  if Pusher?
    pusher = new Pusher("28d86c309600f754848f")
  else
    # if pusher doesn't load
    subscribe: ->
      bind: ->
        true
      unbind: ->
        true

  # Uncomment this during development
  # Pusher.log = (message) ->
  # window.console.log message if window.console and window.console.log

  subscribe: (channel) ->
    pusher.subscribe(channel)

  bind: (event, callback) ->
    channel.bind event, ->
      args = arguments
      $rootScope.$apply ->
        callback.apply channel, args

ocarinaServices.factory 'Playlist', ['$http', ($http) ->
  url = "/api/playlists"
  Playlist = (data) ->
    angular.extend(this, data)

  Playlist.get = (id) ->
    $http.get("#{url}/#{id}.json").then (res) =>
      new Playlist(res.data)

  Playlist.prototype.create = ->
    playlist = this
    $http.post("#{url}.json", playlist)

  Playlist.addSongs = (id, songs) ->
    $http.post("#{url}/#{id}/add_songs.json", song_ids: songs)

  Playlist.vote = (id, song_id, decision) ->
    $http.post("#{url}/#{id}/playlist_songs/#{song_id}/#{decision}")

  Playlist
]

ocarinaServices.factory 'User', ['$http', ($http) ->
  url = "/api/users"
  User = (data) ->
    angular.extend(this, data)

  User.get = (id) ->
    $http.get("#{url}/#{id}.json").then (res) =>
      new User(res.data)

  User.getCurrentUser = ->
    $http.get("/api/current_user.json").then (res) =>
      new User(res.data)

  User
]

ocarinaServices.factory 'Audio', ['$document', '$rootScope', ($document, $rootScope) ->
    Audio = $document[0].createElement('audio')

    Audio.addEventListener "ended", (->
      $rootScope.$broadcast("audioEnded")
    ), false
    Audio.addEventListener "error", (->
      console.log("error")
    ), false

    Audio
]

ocarinaServices.factory 'Player', ['Audio',
  (Audio) ->
    Player = undefined

    current =
      song: 0

    Player =
      audio: Audio
      paused: false
      playing: false
      current: current
      play: (song) ->
        current.song = song if angular.isDefined(song)
        Audio.src = song.media_url unless Player.paused
        Audio.play()
        Player.playing = true
        Player.paused = false
      pause: ->
        if Player.playing
          Audio.pause()
          Player.playing = false
          Player.paused = true

    Player
]
