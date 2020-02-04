require 'rails_helper'

RSpec.describe Api::V1::NpsController, type: :request do
  describe 'POST api/v1/nps' do
    let(:params) do
      {
        touchpoint: 'realtor_feedback',
        object_id: 1,
        object_class: 'realtor',
        respondent_id: 1,
        respondent_class: 'seller',
        score: score
      }
    end
    let(:score) { 5 }

    it 'creates a new nps' do
      expect { post '/api/v1/nps', params: params }.to change { Nps.count }.by(1)

      expect(response.status).to eq(201)
    end

    context 'duplicate nps' do
      let!(:nps) { create(:np, object_id: 1) }

      it 'updates score' do
        expect { post '/api/v1/nps', params: params }.to(
              avoid_changing { Nps.count }
              .and(change { nps.reload.score }.from(3).to(5))
            )

        expect(response.status).to eq(201)
      end
    end

    context 'invalid request' do
      context 'score not in range' do
        let(:score) { 12 }

        it 'returns error' do
          expect { post '/api/v1/nps', params: params }.to_not change { Nps.count }

          expect(response.status).to eq(400)
          expect(json_body).to eq ({'error' => ['Score must be a number between 0 and 10'] })
        end
      end

      context 'missing params' do
        before { params.delete(:touchpoint) }

        it 'returns error' do
          expect { post '/api/v1/nps', params: params }.to_not change { Nps.count }

          expect(response.status).to eq(400)
          expect(json_body).to eq ({'error' => ["Touchpoint can't be blank"] })
        end
      end
    end
  end
end
