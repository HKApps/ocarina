class PartiesController < ApplicationController
  before_filter :require_authentication

  def index_template
    respond_to do |format|
      format.html do
        if current_user
          render :index
        else
          render 'sessions/logged_out_homepage'
        end
      end
    end
  end

  def index
    @parties = Party.where(host_id: current_user.id)
    @party = current_user.parties.build
  end

  def show
    respond_to do |format|
      format.html { @party = Party.find params[:id] }

      format.json do
        @party= Party.find_by id: params[:id]
        if @party
          render json: @party
        else
          render json: {error: "record not found"}, status: 404
        end
      end
    end
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
