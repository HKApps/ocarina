attributes :id, :email, :first_name, :last_name, :image, :created_at, :updated_at

node(:dropbox_authenticated)  { |u| u.dropbox_authenticated? }
node(:facebook_authenticated) { |u| u.facebook_authenticated? }
node(:defer_dropbox_connect)  { |u| defer_dropbox_connect? }
node(:facebook_token)         { |u| u.fetch_authentications.where(provider: "facebook").first.access_token }

node(:skip_song_voted_songs) do |u|
  u.fetch_skip_song_votes.map(&:fetch_playlist_song)
end

child :votes => :votes do
  attributes :decision, :created_at
  node(:song_name) do |v|
    v.playlist_song.song_name
  end
  node(:playlist) do |v|
    v.playlist_song.playlist
  end
end

child :current_dropbox_songs => :dropbox_songs do
  attributes :id, :name, :path, :user_id, :created_at, :updated_at
end

child :current_soundcloud_songs => :soundcloud_songs do
  attributes :id, :name, :path, :user_id, :created_at, :updated_at
end

child :current_saved_songs => :favorites do
  attributes :id, :playlist_song_id, :name
end

child :playlists_as_owner => :playlists do
  attributes :id, :name, :location, :created_at, :updated_at
end

child :playlists_as_guest => "playlists_as_guest" do
  attributes :id, :name, :location, :owner_id, :updated_at, :created_at
end

child :playlist_songs_added => :playlist_songs_added do
  attributes :id, :song_name, :provider, :created_at
end
