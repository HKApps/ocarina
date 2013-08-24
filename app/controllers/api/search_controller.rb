class Api::SearchController < ApiController
  respond_to :json

  def index
    results = {
      users:     User.fuzzy_search(params[:query]),
      playlists: Playlist.fuzzy_search(params[:query])
    }

    respond_with results
  end
end
