class Api::V1::NpsController < ApplicationController
  #included because API, not included by default

  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :authenticate

  def create
    nps = Nps.find_or_initialize_by(nps_params.except(:score))

    if nps.update(score: nps_params[:score])
      render json: nps, status: 201
    else
      render json: { error: nps.errors.full_messages }, status: 400
    end
  end

  def index
    nps = Nps.where(nps_fetch_params)

    render json: nps, status: 200

  rescue ActionController::ParameterMissing => e
    render json: e, status: 400
  end

  private

  def authenticate
    authenticate_or_request_with_http_token do |token, options|
      # Compare the tokens in a time-constant manner, to mitigate
      # timing attacks.
      ActiveSupport::SecurityUtils.secure_compare(token, ENV['AUTH_TOKEN'])
    end
  end

  def nps_params
    params.permit(:score, :touchpoint, :object_id, :object_class, :respondent_id, :respondent_class)
  end

  def nps_fetch_params
    params.require(:touchpoint)
    params.permit(:touchpoint, :object_class, :respondent_class)
  end
end
