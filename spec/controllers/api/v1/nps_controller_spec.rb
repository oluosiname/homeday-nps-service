require 'rails_helper'

RSpec.describe Api::V1::NpsController, type: :request do
  subject { post '/api/v1/nps', params: params,  headers: { 'HTTP_AUTHORIZATION' => authorization } }

  let(:token) { 'good_token' }

  let(:authorization) do
    authorization = ActionController::HttpAuthentication::Token.encode_credentials(token)
  end

  before do
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with('AUTH_TOKEN').and_return('good_token')
  end

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

    context 'unauthorized request' do
      let(:token) { 'bad_token' }

      it 'does not create a new nps' do
        expect { subject }.to_not change { Nps.count }
        expect(response.status).to eq(401)
      end
    end

    it 'creates a new nps' do
      expect { subject }.to change { Nps.count }.by(1)
      expect(response.status).to eq(201)
    end

    context 'duplicate nps' do
      let!(:nps) { create(:np, object_id: 1) }

      it 'updates score' do
        expect { subject }.to(
              avoid_changing { Nps.count }
              .and(change { nps.reload.score }.from(3).to(5))
            )

        expect(response.status).to eq(201)
      end
    end

    context 'invalid request' do
      context 'score not in range' do
        let(:score) { 12 }

        it_behaves_like 'a request with invalid params', 'Score must be a number between 0 and 10'
      end

      context 'missing params' do
        parameters = [
                       { name: :touchpoint, error: "Touchpoint can't be blank" },
                       { name: :score, error: "Score can't be blank" },
                       { name: :object_id, error: "Object can't be blank" },
                       { name: :object_class, error: "Object class can't be blank" },
                       { name: :respondent_id, error: "Respondent can't be blank" },
                       { name: :respondent_class, error: "Respondent class can't be blank" },
                     ]
        parameters.each do |parameter|

          context "missing #{parameter[:name]}" do
            before { params.delete(parameter[:name]) }

            it_behaves_like 'a request with invalid params', parameter[:error]
          end
        end
      end
    end
  end

  describe 'GET api/v1/nps' do
    subject { get '/api/v1/nps', params: params,  headers: { 'HTTP_AUTHORIZATION' => authorization } }
    let(:params) do
      {
        touchpoint: 'realtor_feedback',
        respondent_class: 'seller',
        object_class: 'realtor'
      }
    end

    let!(:saved_nps) { create(:np, object_id: 1) }

    context 'unauthorized request' do
      let(:token) { 'bad_token' }

      it 'raises unauthorized error' do
        subject

        expect(response.status).to eq(401)
      end
    end

    it 'returns all matching nps' do
      subject

      expect(json_body).to eq ([
        {
          "id" => saved_nps.id,
          "object_class" => saved_nps.object_class,
          "object_id" => saved_nps.object_id,
          "respondent_id" => saved_nps.respondent_id,
          "respondent_class" => saved_nps.respondent_class,
          "score" => saved_nps.score,
          "touchpoint" => saved_nps.touchpoint
        }
      ])
    end

    context 'touchpoint not passed' do
      let(:params) do
        {
          respondent_class: 'seller',
          object_class: 'realtor'
        }
      end

      it 'returns all matching nps' do
        subject

        expect(json_body).to eq ('param is missing or the value is empty: touchpoint')
      end
    end

    context 'touchpoint is empty' do
      let(:params) do
        {
          touchpoint: '',
          respondent_class: 'seller',
          object_class: 'realtor'
        }
      end

      it 'returns all matching nps' do
        subject

        expect(json_body).to eq ('param is missing or the value is empty: touchpoint')
      end
    end

    context 'optional params not passed' do
      let(:params) do
        {
          touchpoint: 'realtor_feedback'
        }
      end

      it 'returns all matching nps' do
        subject

        expect(json_body).to eq ([
          {
            "id" => saved_nps.id,
            "object_class" => saved_nps.object_class,
            "object_id" => saved_nps.object_id,
            "respondent_id" => saved_nps.respondent_id,
            "respondent_class" => saved_nps.respondent_class,
            "score" => saved_nps.score,
            "touchpoint" => saved_nps.touchpoint
          }
        ])
      end
    end
  end
end

