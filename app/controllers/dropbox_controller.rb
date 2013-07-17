class DropboxController < ApplicationController
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
    FileToSongService.new(dropbox_client.all_song_files, current_user).convert_and_save
    redirect_to :root
  end
end
