class Api::PlaylistsController < ApiController
  def index
    @playlists = Playlist.where(host_id: current_user.id)
    @playlist = current_user.playlists.build
  end

  def show
    respond_to do |format|
      format.html do
        if current_user
          render :index
        else
          render 'sessions/logged_out_homepage'
        end
      end

      format.json do
        @playlist = Playlist.includes(:playlist_songs).where(id: params[:id]).first
      end
    end
  end

  def create
    respond_to do |format|
      format.html do
        current_user.playlists.create(playlist_params)
        redirect_to :root
      end

      format.json do
        playlist = current_user.playlists.build(playlist_params)
        if playlist.save
          render json: playlist, status: 201
        else
          render json: playlist.errors, status: :unauthorized
        end
      end
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
