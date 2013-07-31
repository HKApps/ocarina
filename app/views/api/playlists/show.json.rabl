object @playlist
attributes :id, :name, :owner_id, :updated_at, :created_at

child :unplayed_songs => "playlist_songs" do
  attributes :id, :playlist_id, :song_id, :vote_count, :path, :media_url, :song_name

  node :current_user_vote_decision do |ps|
    Vote.where(user_id: current_user.id, playlist_song_id: ps.id).first.try(:decision) || 0
  end
end
