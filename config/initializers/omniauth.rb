Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_APP_SECRET'],
    {scope: 'email,user_events,publish_stream', display: 'popup'}
  provider :dropbox, ENV['DROPBOX_APP_KEY'], ENV['DROPBOX_APP_SECRET']
end
