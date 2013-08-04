class Api::PlaylistsController < ApiController
  respond_to :json
  before_filter :fetch_playlist

  def show
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

  def join
    if @playlist
      JoinPlaylistWorker.perform_async(params[:id], current_user.id)
      render "api/playlists/join", status: 201
    else
      render json: {error: "record not found"}, status: 403
    end
  end

  private

  def fetch_playlist
    @playlist = Playlist.includes(playlist_songs: :votes).where(id: params[:id]).first
  end

  def playlist_params
    params.require(:playlist).permit(:name)
  end

  def add_song_params
    params.permit(:id, :song_ids)
  end
end
