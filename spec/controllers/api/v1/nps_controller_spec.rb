require 'rails_helper'

RSpec.describe Api::V1::NpsController, type: :request do
  describe 'POST api/v1/nps' do
    let(:params) do
      {
        touchpoint: 'realtor_feedback'
      }
    end

    it 'creates a new nps' do
      expect { post '/api/v1/nps', params: params }.to change { Nps.count }.by(1)
      expect(response.status).to eq(201)
    end
  end
end
