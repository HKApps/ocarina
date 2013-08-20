class Api::SavedSongsController < ApiController
  respond_to :json

  def index
    @saved_songs = current_user.saved_songs
    respond_with @saved_songs, status: 201
  end

  def create
    @saved_song = SavedSong.new do |ss|
      ss.playlist_song_id = params[:id]
      ss.user_id          = current_user.id
      ss.name             = params[:song_name]
    end

    if @saved_song.save
      render json: @saved_song, status: 201
    else
      respond_with @saved_song.errors, status: 404
    end
  end

  def destroy
    @saved_song = SavedSong.where(id: params[:id]).first
    if @saved_song.destroy
      respond_with status: 201
    else
      respond_with status: 404
    end
  end
end
