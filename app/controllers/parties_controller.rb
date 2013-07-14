class PartiesController < ApplicationController
  before_filter :require_authentication

  def index
    @parties = Party.where(host_id: current_user.id)
    @party = current_user.parties.build
  end

  def show
    @party = Party.find params[:id]
  end

  def create
    party = current_user.parties.create(party_params)
    redirect_to :root
  end

  private

  def party_params
    params.require(:party).permit(:name)
  end
end
