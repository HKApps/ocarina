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

ocarinaServices.factory 'AudioService', ->
  params = {
    swf_path: '/flash/audio5js.swf',
    throw_errors: true,
    format_time: true,
    codecs: ['mp4', 'wav', 'mp3'],
    ready: (player) ->
      # Im trying to get this to load but its not working. Maybe a js loading issue?
      @load("https://dl.dropboxusercontent.com/1/view/wdgou8i5w5wo3v0/Apps/PlayedBy.me/Arston%20-%20Zodiac%20%5BEDX%20No%20Xcuses%20113%204-28-13%5D.mp3")
  }

  audio5js = new Audio5js(params)

  audio5js
