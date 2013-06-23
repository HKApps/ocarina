require 'dropbox-api'

class DropboxClient < Dropbox::API::Client
  attr_reader :client

  def initialize(access_token, access_secret)
    @client = super(token: access_token, secret: access_secret)
  end

  def media_url(path)
    @client.raw.metadata(path: path)
  end
end
