class AddSkipSongVoteCountToPlaylistSongs < ActiveRecord::Migration
  def change
    add_column :playlist_songs, :skip_song_vote_count, :integer, default: 0
  end
end
