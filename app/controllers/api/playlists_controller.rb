class Api::PlaylistsController < ApiController
  respond_to :json
  before_filter :fetch_playlist, only: [:show, :join]

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
    @playlist.venue = params[:playlist][:venue]
    if @playlist.save
      respond_with @playlist, status: 201
    else
      respond_with @playlist.errors, status: :unauthorized
    end
  end

  def join
    if @playlist
      JoinPlaylistWorker.new.async.perform(params[:id], current_user.id)
      push_guest(current_user, params[:id])
      render "api/playlists/join", status: 201
    else
      render json: {error: "record not found"}, status: 403
    end
  end

  def current_song_request
    Pusher.trigger("playlist-#{params[:id]}", "current-song-request", { playlist_id: params[:id] } )
    respond_to do |format|
      format.json { head :ok }
    end
  end

  def current_song_response
    Pusher.trigger("playlist-#{params[:id]}", "current-song-response", { song: params[:song] })
    respond_to do |format|
      format.json { head :ok }
    end
  end

  def push_guest(guest, playlist_id)
    Pusher.trigger("playlist-#{playlist_id}", "new-guest", { guest: guest } )
  end

  private

  def fetch_playlist
    @playlist = Playlist.fetch params[:id]
  end

  def playlist_params
    params.require(:playlist).permit(:name, :location, :private, :start_time, :facebook_id)
  end

  def add_song_params
    params.permit(:id, :song_ids)
  end
end
