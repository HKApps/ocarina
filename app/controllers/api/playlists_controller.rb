class Api::PlaylistsController < ApiController
  respond_to :json

  def show
    @playlist = Playlist.includes(:playlist_songs).where(id: params[:id]).first
    respond_with @playlist
  end

  def index
    @playlists = Playlist.all
    respond_to do |format|
      format.json { render :json => @playlists }
    end
  end

  def create
    @playlist = current_user.playlists.build(playlist_params)
    if @playlist.save
      respond_with @playlist, status: 201
    else
      respond_with @playlist.errors, status: :unauthorized
    end
  end

  private

  def playlist_params
    params.require(:playlist).permit(:name)
  end

  def add_song_params
    params.permit(:id, :song_ids)
  end
end
