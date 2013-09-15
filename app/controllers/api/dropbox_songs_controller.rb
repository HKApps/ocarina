class Api::DropboxSongsController < ApiController
  respond_to :json

  def index
    respond_to do |format|
      format.json do
        # TODO(mn) - Add caching layer and check for changes before hitting DB.
        metadata = dropbox_client.metadata
        if metadata
          render json: dropbox_client.metadata
        else
          render json: {error: "dropbox server error"}, status: 404
        end
      end
    end
  end

  def create
    FileToSongService.new(dropbox_client.all_song_files, user_id).convert_and_save
    redirect_to :root
  end

  def update
    service = UpdateDropboxSongsService.new(user_id)
    if service.update_songs
      @songs = service.convert_to_songs
      service.write_cache(service.dropbox_client.metadata)
    else
      render json: {}, status: 304
    end
  end

  private

  def dropbox_client
    @dropbox_client ||= DropboxClient.new(dropbox_auth.access_token, dropbox_auth.access_token_secret)
  end

  def dropbox_auth
    @dropbox_auth ||= Authentication.find_by user_id: user_id, provider: 'dropbox'
  end

end
