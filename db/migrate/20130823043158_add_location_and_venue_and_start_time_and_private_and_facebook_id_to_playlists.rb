class AddLocationAndVenueAndStartTimeAndPrivateAndFacebookIdToPlaylists < ActiveRecord::Migration
  def change
    add_column :playlists, :location, :string
    add_column :playlists, :venue, :hstore
    add_column :playlists, :start_time, :datetime
    add_column :playlists, :private, :boolean, default: false
    add_column :playlists, :facebook_id, :string
  end
end
