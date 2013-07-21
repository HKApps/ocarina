class PlaylistsController < ApplicationController
  before_filter :require_authentication

  def index_template
    respond_to do |format|
      format.html do
        if current_user
          render :index
        else
          render 'sessions/logged_out_homepage'
        end
      end
    end
  end

  def index
    @playlists = Playlist.where(host_id: current_user.id)
    @playlist = current_user.playlists.build
  end

  def show
    respond_to do |format|
      format.html do
        render :index
      end

      format.json do
        @playlist= Playlist.find_by id: params[:id]
        if @playlist
          render json: @playlist, include: :playlist_songs
        else
          render json: {error: "record not found"}, status: 404
        end
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

  def add_songs
    playlists = AddPlaylistSongToPlaylistService.initialize_from_params(params).create
    if playlists.present?
      render json: playlists, status: 201
    else
      respond_with({error: "record not found"}, status: 404)
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
