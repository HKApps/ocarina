Rails.application.config.action_mailer.default_url_options = {
  :host => Rails.configuration.web_url
}

Rails.application.config.action_mailer.smtp_settings = {
  address:              'smtp.gmail.com',
  port:                 587,
  domain:               'gmail.com',
  user_name:            Rails.configuration.smtp_user_name,
  password:             Rails.configuration.smtp_password,
  authentication:       'plain',
  enable_starttls_auto: true
}
