require 'rails_helper'

describe 'Answer API', type: :request do
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
      let(:answer) { create(:answer, question: question, user: User.find(access_token.resource_owner_id)) }
      let(:update_path) { "/api/v1/answers/#{answer.id}" }

      context 'with valid attributes' do
        let(:send_request) { patch update_path, params: { id: answer, answer: { body: 'new body'}, access_token: access_token.token } }

        it 'assigns the requested answer to @answer' do
          send_request
          expect(assigns(:answer)).to eq answer
        end

        it 'change answer attributes' do
          send_request
          answer.reload

          expect(answer.body).to eq 'new body'
        end

        it 'status success' do
          send_request
          expect(response.status).to eq 200
        end
      end

      context 'with invalid attributes' do
        let(:send_bad_request) { patch update_path, params: { id: answer, answer: attributes_for(:answer, :invalid), access_token: access_token.token } }

        it 'does not update question' do
          body = answer.body
          send_bad_request
          answer.reload

          expect(answer.body).to eq body
        end

        it 'does not create question' do
          send_bad_request
          expect(response.status).to eq 400
        end
      end
    end
  end
end