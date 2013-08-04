attributes :id, :name, :owner_id, :updated_at, :created_at

child :unplayed_songs => "playlist_songs" do
  attributes :id, :playlist_id, :song_id, :vote_count, :path, :media_url, :song_name

  node :current_user_vote_decision do |ps|
    ps.votes.select { |v| v.user_id == current_user.id }.first.try(:decision) || 0
  end
end
