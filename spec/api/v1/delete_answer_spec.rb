require 'rails_helper'

describe 'Question API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end

  describe 'PATCH /api/v1/answers/id' do
    let(:api_path) { '/api/v1/answers/id' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:question) { create(:question, user: create(:user)) }
      let!(:answer) { create(:answer, question: question, user: User.find(access_token.resource_owner_id)) }
      let(:delete_path) { "/api/v1/answers/#{answer.id}" }

      context 'with valid attributes' do
        let(:send_request) { delete delete_path, params: { id: answer, access_token: access_token.token } }

        it 'delete the answer' do
          expect { send_request }.to change(Answer, :count).by(-1)
        end
        it 'status success' do
          send_request
          expect(response.status).to eq 204
        end
      end
    end
  end
end