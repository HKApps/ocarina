attributes :id, :email, :first_name, :last_name, :image, :created_at, :updated_at

node(:dropbox_authenticated)  { |u| u.dropbox_authenticated? }
node(:facebook_authenticated) { |u| u.facebook_authenticated? }
node(:defer_dropbox_connect)  { |u| defer_dropbox_connect? }

child :current_dropbox_songs => "dropbox_songs" do
  attributes :id, :name, :path, :user_id, :created_at, :updated_at
end

child :current_soundcloud_songs => "soundcloud_songs" do
  attributes :id, :name, :path, :user_id, :created_at, :updated_at
end

child :playlists_as_owner => :playlists do
  attributes :id, :name, :created_at, :updated_at
end

child :playlists_as_guest => "playlists_as_guest" do
  attributes :id, :name, :owner_id, :updated_at, :created_at
end
