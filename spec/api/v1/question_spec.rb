require 'rails_helper'

describe 'Question API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end

  describe 'GET /api/v1/questions/id' do
    let(:api_path) { '/api/v1/questions/id' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      include ControllerHelpers

      let(:user) { create(:user) }
      let(:access_token) { create(:access_token) }
      let(:question) { create(:question, user: user) }
      let!(:comments) { create_list(:comment, 3, commentable: question, user: user) }
      let!(:links) { create_list(:link, 3, linkable: question) }
      before { 3.times { attach_file_to(question) } }

      let(:object_response) { json['question'] }

      before { get "/api/v1/questions/#{question.id}", params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all question public fields' do
        %w[id title body user_id created_at updated_at].each do |attr|
          expect(object_response[attr]).to eq question.send(attr).as_json
        end
      end

      it_behaves_like 'API comments'

      it_behaves_like 'API links'

      it_behaves_like 'API files' do
        let(:item) { question }
      end
    end
  end
end