attributes :id, :name, :owner_id, :private, :created_at

child :host => "host" do
  attributes :id, :first_name, :last_name, :image
end

child :guests_as_users => "guests" do
  attributes :id, :first_name, :last_name, :image
end

child :unplayed_songs => "playlist_songs" do
  attributes :id, :playlist_id, :song_id, :vote_count, :path, :media_url, :song_name, :provider

  node :current_user_vote_decision do |ps|
    ps.fetch_votes.select { |v| v.user_id == current_user.id }.first.try(:decision) || 0
  end

  node :voters do |ps|
    ps.fetch_votes.map(&:user)
  end
end

child :played_songs => "played_playlist_songs" do
  attributes :id, :playlist_id, :song_id, :vote_count, :path, :media_url, :song_name, :provider
end
