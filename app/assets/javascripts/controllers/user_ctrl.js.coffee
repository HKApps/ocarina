ocarina.controller 'UserCtrl', ['User', '$http', '$scope',
  (User, $http, $scope) ->
    $scope.loggedIn = false

    $scope.logout = ->
      $scope.loggedIn = false
      deleteCookie("user_id")
      FB.logout()

    $scope.login = ->
      FB.login ((response) ->
        # handle the response
      ),
        scope: "email,user_events,publish_stream"

    setCookie = (c_name, value, exdays) ->
      exdate = new Date()
      exdate.setDate exdate.getDate() + exdays
      c_value = escape(value) + ((if (not (exdays?)) then "" else "; expires=" + exdate.toUTCString()))
      document.cookie = c_name + "=" + c_value

    deleteCookie = (c_name) ->
      setCookie(c_name, "", -1)

    getCookie = (c_name) ->
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

    if getCookie("user_id")
      $scope.loggedIn = true
      User.get(getCookie("user_id")).then (u) =>
        $scope.currentUser = u

        $scope.currentUser.hasPlaylists = ->
          $scope.currentUser.playlists.length > 0

        $scope.currentUser.hasPlaylistsAsGuest = ->
          $scope.currentUser.playlists_as_guest.length > 0

        $scope.deferDropboxConnect = ->
          $http.post("/defer_dropbox_connect").then () =>
            $scope.currentUser.defer_dropbox_connect = true
]
