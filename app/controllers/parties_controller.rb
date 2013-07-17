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
    respond_to do |format|
      format.html do
        current_user.parties.create(party_params)
        redirect_to :root
      end

      format.json do
        party = current_user.parties.build(party_params)
        if party.save
          render json: party, status: 201
        else
          render json: party.errors, status: :unauthorized
        end
      end
    end
  end

  private

  def party_params
    params.require(:party).permit(:name)
  end
end
