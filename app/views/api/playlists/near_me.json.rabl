collection @playlists

attributes :id, :name, :owner_id, :private, :created_at, :settings

node(:distance) do |p|
  proxim = @proxim.select { |prox| p.id == prox[:playlist_id] }
  proxim.first[:distance]
end
