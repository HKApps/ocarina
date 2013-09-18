Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_APP_SECRET'],
    {scope: 'email,user_events,user_friends,user_likes,friends_likes,publish_stream', display: 'page'}
  provider :dropbox, ENV['DROPBOX_APP_KEY'], ENV['DROPBOX_APP_SECRET']
end
