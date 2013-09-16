this.setCookie = (c_name, value, exdays) ->
  exdate = new Date()
  exdate.setDate exdate.getDate() + exdays
  c_value = escape(value) + ((if (not (exdays?)) then "" else "; expires=" + exdate.toUTCString()))
  document.cookie = c_name + "=" + c_value

this.getCookie = (c_name) ->
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

window.fbAsyncInit = ->
  FB.init
    appId: "160916744087752"
    channelUrl: "//localhost:4400/channel.html"
    status: true # check login status
    cookie: true # enable cookies to allow the server to access the session
    xfbml: true # parse XFBML
  FB.Event.subscribe "auth.authResponseChange", (res) ->
    if res.status is "connected"
      return if this.getCookie("user_id")
      auth = res.authResponse
      FB.api '/me?fields=picture,first_name,last_name,email', (res) ->
        authParams =
          id: res.id
          first_name: res.first_name
          last_name: res.last_name
          email: res.last_name
          image: res.picture.data.url
          access_token: auth.accessToken
        $.get "/api/users/authenticate.json", authParams, (data) ->
          window.setCookie("user_id", data.id, 1)
          window.location.replace "http://localhost:4400?user_id=#{data.id}"
    else if res.status is "not_authorized"
      # if user logged in but hasn't authed app
    else
      # if user logged out

# Load the SDK asynchronously
((d) ->
  js = undefined
  id = "facebook-jssdk"
  ref = d.getElementsByTagName("script")[0]
  return  if d.getElementById(id)
  js = d.createElement("script")
  js.id = id
  js.async = true
  js.src = "//connect.facebook.net/en_US/all.js"
  ref.parentNode.insertBefore js, ref
) document
