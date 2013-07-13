class DropboxController < ApplicationController
  def create
    FileToSongService.new(dropbox_client.all_song_files, current_user).convert_and_save
    redirect_to :root
  end
end
