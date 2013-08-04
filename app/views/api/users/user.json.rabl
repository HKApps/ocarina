attributes :id, :email, :first_name, :last_name, :image, :created_at, :updated_at

node(:dropbox_authenticated)  { |u| u.dropbox_authenticated? }
node(:facebook_authenticated) { |u| u.facebook_authenticated? }

child :songs => "dropbox_songs" do
  attributes :id, :name, :path, :user_id, :properties, :created_at, :updated_at
end

child :playlists do
  attributes :id, :name, :created_at, :updated_at
end

child :guests => "playlists_as_guest" do
  attributes :id, :playlist_name, :user_id, :playlist_id, :created_at, :updated_at
end

