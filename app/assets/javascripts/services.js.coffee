# API URL
@apiURL = ""

ocarinaServices = angular.module('ocarinaServices', [])

ocarinaServices.factory 'Pusher', ->
  if Pusher?
    pusher = new Pusher("e9eb3f912d37215f7804")
  else
    # if pusher doesn't load
    subscribe: ->
      bind: ->
        true
      unbind: ->
        true

# Uncomment this during development
# Pusher.log = (message) ->
#  window.console.log message if window.console and window.console.log

ocarinaServices.factory 'Authentication', ['$http', ($http) ->
  Authentication = (data) ->
    angular.extend(this, data)

  Authentication.loggedIn = false

  Authentication.setCookie = (c_name, value, exdays) ->
    exdate = new Date()
    exdate.setDate exdate.getDate() + exdays
    c_value = escape(value) + ((if (not (exdays?)) then "" else "; expires=" + exdate.toUTCString()))
    document.cookie = c_name + "=" + c_value

  Authentication.getCookie = (c_name) ->
    c_value = document.cookie
    c_start = c_value.indexOf(" " + c_name + "=")
    c_start = c_value.indexOf(c_name + "=")  if c_start is -1
    if c_start is -1
      c_value = null
    else
      c_start = c_value.indexOf("=", c_start) + 1
      c_end = c_value.indexOf(";", c_start)
      c_end = c_value.length  if c_end is -1
      c_value = unescape(c_value.substring(c_start, c_end))
      c_value

  Authentication.deleteCookie = (c_name) ->
    Authentication.setCookie(c_name, "", -100)

  Authentication.login = ->
    FB.login ((response) ->
      Authentication.loggedIn = true
    ),
      scope: "email,user_events,publish_stream"

  Authentication.logout = ->
    Authentication.deleteCookie("user_id")
    FB.logout()
    Authentication.loggedIn = false

  FB.init
    appId: "160916744087752"
    channelUrl: "//localhost:4400/channel.html"
    status: true # check login status
    cookie: true # enable cookies to allow the server to access the session
    xfbml: true # parse XFBML

  FB.Event.subscribe "auth.authResponseChange", (res) ->
    if res.status is "connected"
      return if Authentication.getCookie("user_id")
      auth = res.authResponse
      FB.api '/me?fields=picture,first_name,last_name,email', (res) ->
        authParams =
          id: res.id
          first_name: res.first_name
          last_name: res.last_name
          email: res.last_name
          image: res.picture.data.url
          access_token: auth.accessToken
        $.get "#{apiURL}/api/users/authenticate.json", authParams, (data) ->
          Authentication.setCookie("user_id", data.id, 1)
          window.location.replace "http://localhost:4400?user_id=#{data.id}"
    else if res.status is "not_authorized"
      # if user logged in but hasn't authed app
    else
      # if user logged out

  Authentication
]

ocarinaServices.factory 'Playlist', ['$http', ($http) ->
  url = apiURL + "/api/playlists"
  Playlist = (data) ->
    angular.extend(this, data)

  Playlist.getIndex = (user_id) ->
    $http.get("#{url}.json")

  Playlist.get = (user_id, playlist_id) ->
    $http.get("#{url}/#{playlist_id}.json",
      params: { user_id: user_id }
    ).then (res) =>
      new Playlist(res.data)

  Playlist.prototype.create = (user_id) ->
    $http.post("#{url}.json",
      user_id: user_id
      playlist: this
    )

  Playlist.join = (user_id, playlist_id, password) ->
    $http.post("#{url}/#{playlist_id}/join",
      user_id: user_id
      password: password
    )

  Playlist.addSongs = (user_id, playlist_id, songs) ->
    $http.post "#{url}/#{playlist_id}/add_songs.json",
      user_id: user_id
      dropbox: songs["dropbox"]
      soundcloud: songs["soundcloud"]

  Playlist.vote = (user_id, playlist_id, song_id, decision) ->
    $http.post("#{url}/#{playlist_id}/playlist_songs/#{song_id}/#{decision}",
      user_id: user_id
    )

  Playlist.getMediaURL = (user_id, playlist_id, song_id) ->
    $http.get("#{url}/#{playlist_id}/playlist_songs/#{song_id}/media_url.json",
      params: { user_id: user_id }
    )

  Playlist.getCurrentSong = (user_id, playlist_id) ->
    $http.get("#{url}/#{playlist_id}/current_song_request.json",
      params: { user_id: user_id }
    )

  Playlist.respondCurrentSong = (user_id, playlist_id, song) ->
    $http.post("#{url}/#{playlist_id}/current_song_response.json",
      user_id: user_id
      song: song
    )

  Playlist.songPlayed = (user_id, playlist_id, song_id) ->
    $http.post("#{url}/#{playlist_id}/playlist_songs/#{song_id}/played.json",
      user_id: user_id
    )

  Playlist.playbackEnded = (user_id, playlist_id) ->
    $http.post("#{url}/#{playlist_id}/playback_ended.json",
      user_id: user_id
    )

  Playlist.skipSongVote = (user_id, playlist_id, song_id) ->
    $http.post("#{url}/#{playlist_id}/playlist_songs/#{song_id}/skip_song_vote.json",
      user_id: user_id
    )

  Playlist
]

ocarinaServices.factory 'User', ['$http', ($http) ->
  url = apiURL + "/api/users"
  User = (data) ->
    angular.extend(this, data)

  User.get = (id) ->
    $http.get("#{url}/#{id}.json").then (res) =>
      new User(res.data)

  User
]

ocarinaServices.factory 'Audio', ['$document', '$rootScope',
  ($document, $rootScope) ->
    Audio = $document[0].createElement('audio')
    Audio.preload = "auto"

    Audio.addEventListener "durationchange", (->
      $rootScope.$broadcast("audioDurationchange")
    ), false
    Audio.addEventListener "loadedmetadata", (->
      $rootScope.$broadcast("audioLoadedMetadata")
    ), false
    Audio.addEventListener "timeupdate", (->
      $rootScope.$broadcast("audioTimeupdate")
    ), false
    Audio.addEventListener "progress", (->
      $rootScope.$broadcast("audioProgress")
    ), false
    Audio.addEventListener "ended", (->
      $rootScope.$broadcast("audioEnded")
    ), false
    Audio.addEventListener "error", (->
      console.log("error playing that song")
      $rootScope.$broadcast("audioError")
    ), false

    Audio
]

ocarinaServices.factory 'Player', ['Audio', (Audio) ->
  Player =
    playlistId: undefined
    currentSong: undefined
    audio: Audio
    state: undefined
    play: (song) ->
      if angular.isDefined(song)
        Audio.src = song.media_url
      Audio.play()
      Player.state = 'playing'
    pause: ->
      Audio.pause()
      Player.state = 'paused'
    stop: (playlistId) ->
      Audio.pause()
      Player.currentSong = undefined
      Player.state = undefined
      Player.playlistId = playlistId

  Player
]

ocarinaServices.factory 'Facebook', ['$http', ($http) ->
  graph_url = "https://graph.facebook.com"
  api_url   = "http://facebook.com"
  app_id    = '227387824081363'

  Facebook = (data) ->
    angular.extend(this, data)

  Facebook.getEvents = (token) ->
    $http.get("#{graph_url}/me/events?fields=name,location,venue,privacy&type=attending&access_token=#{token}")

  Facebook.postOnEvent = (token, id, message, link, name) ->
    caption = "www.playedby.me"
    description = "Share. Vote. Discover."
    $http.post "#{graph_url}/#{id}/feed?access_token=#{token}&message=#{message}&link=#{link}&name=#{name}&caption=#{caption}&description=#{description}"

  Facebook.sendDialogURL = (playlist_id) ->
    link = "http://played-by-me.herokuapp.com/playlists/#{playlist_id}"
    "#{api_url}/dialog/send?app_id=#{app_id}&link=#{link}&redirect_uri=#{link}"

  Facebook.getUsersFavoriteArtists = (token, id) ->
    $http.get("#{graph_url}/#{id}/music?access_token=#{token}").then (res) =>
      artists = []
      _.each res.data.data, (artist) ->
        artists.push(artist.name)
      artists

  Facebook.getPartiesFavoriteArtists = (token, ids) ->
    $http.get("#{graph_url}/fql/?q=SELECT music FROM user WHERE uid IN (#{ids}) &access_token=#{token}").then (res) =>
      getSortedArtists(res.data.data)

  Facebook.getEventsFavoriteArtists = (token, event_id) ->
    $http.get("#{graph_url}/fql/?q=SELECT music FROM user WHERE uid IN (SELECT uid FROM event_member WHERE eid=#{event_id} AND rsvp_status='attending') AND uid IN (SELECT uid2 FROM friend WHERE uid1 = me())&access_token=#{token}").then (res) =>
      getSortedArtists(res.data.data)

  getSortedArtists = (data) ->
    # find like count per artists
    groupedArtists = {}
    _.each data, (user) ->
      artists = user.music.split(", ")
      _.each artists, (artist) ->
        unless artist is ""
          if groupedArtists[artist]
            groupedArtists[artist]++
          else
            groupedArtists[artist] = 1

    # categorize artists by like count
    ranks = {}
    max_rank = 0
    for artist of groupedArtists
      max_rank = groupedArtists[artist] if groupedArtists[artist] > max_rank
      if ranks[groupedArtists[artist]]
        ranks[groupedArtists[artist]].push artist
      else
        ranks[groupedArtists[artist]] = [artist]

    # add artists to array in order of rank
    sortedArtists = []
    i = max_rank
    while i > 0
      sortedArtists = sortedArtists.concat(ranks[i] or [])
      i--

    sortedArtists

  Facebook
]
