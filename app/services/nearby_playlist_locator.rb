class NearbyPlaylistLocator
  def self.find(lat, long)
    Playlist.all.map do |playlist|
      next if !playlist.venue
      h_distance = Haversine.distance(
        lat,
        long,
        playlist.venue["latitude"].to_f,
        playlist.venue["longitude"].to_f
      ).to_miles

      {
        playlist_id: playlist.id,
        distance: h_distance
      }
    end.sort_by { |k,v| v }
  end
end
