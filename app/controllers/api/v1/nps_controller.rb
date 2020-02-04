class Api::V1::NpsController < ApplicationController
  def create
    nps = Nps.find_or_initialize_by(nps_params.except(:score))

    if nps.update(score: nps_params[:score])
      render json: nps, status: 201
    else
      render json: { error: nps.errors.full_messages }, status: 400
    end
  end

  private

  def nps_params
    params.permit(:score, :touchpoint, :object_id, :object_class, :respondent_id, :respondent_class)
  end
end
