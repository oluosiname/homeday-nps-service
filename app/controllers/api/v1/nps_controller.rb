class Api::V1::NpsController < ApplicationController
  def create
    nps = Nps.new(nps_params)
    begin
      nps.save!
    rescue

    end
    render json: nps, status: 201
  end

  private

  def nps_params
    params.permit(:score, :touchpoint, :object_id, :object_class, :respondent_id, :respondent_class)
  end
end
