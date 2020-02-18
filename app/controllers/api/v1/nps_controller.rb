class Api::V1::NpsController < ApplicationController
  #included because API, not included by default

  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :authenticate, only: :index

  def create
    data = request.body.read
    verified = verify_request(data, request.env["HTTP_X_HOMEDAY_HMAC_SHA256"])

    unless verified
      return  render json: { error: "Unauthorized request" }, status: 401
    end

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

  def verify_request(data, hmac_header)
    calculated_hmac = Base64.strict_encode64(OpenSSL::HMAC.digest('sha256', ENV['SHARED_SECRET'], data))
    ActiveSupport::SecurityUtils.secure_compare(calculated_hmac, hmac_header)
  end

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
