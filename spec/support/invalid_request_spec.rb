RSpec.shared_examples 'a request with invalid params' do |error|
  it "returns error and does not create nps" do
    expect { subject }.to_not change { Nps.count }

    expect(response.status).to eq(400)
    expect(json_body['error']).to include(error)
  end
end
