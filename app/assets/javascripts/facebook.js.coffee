window.fbAsyncInit = ->
  FB.init
    appId: "160916744087752"
    channelUrl: "//localhost:4400/channel.html"
    status: true # check login status
    cookie: true # enable cookies to allow the server to access the session
    xfbml: true # parse XFBML
  FB.Event.subscribe "auth.authResponseChange", (res) ->
    if res.status is "connected"
      auth = res.authResponse
      FB.api '/me?fields=picture,first_name,last_name,email', (res) ->
        console.log JSON.stringify(auth)
        console.log JSON.stringify(res)
        console.log "going to redirect you, jarp"
    else if res.status is "not_authorized"
      console.log "showing the logged out view"
    else
      console.log "showing the logged out view"

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
