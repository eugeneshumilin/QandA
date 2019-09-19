require 'rails_helper'

describe 'Question API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end

  describe 'PATCH /api/v1/questions/id' do
    let(:api_path) { '/api/v1/questions/id' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:question) { create(:question, user: User.find(access_token.resource_owner_id)) }
      let(:update_path) { "/api/v1/questions/#{question.id}" }

      context 'with valid attributes' do
        let(:send_request) { patch update_path, params: { id: question, question: { title: 'new title', body: 'new body'}, access_token: access_token.token } }

        it 'assigns the requested question to @question' do
          send_request
          expect(assigns(:question)).to eq question
        end

        it 'change question attributes' do
          send_request
          question.reload

          expect(question.title).to eq 'new title'
          expect(question.body).to eq 'new body'
        end

        it 'status success' do
          send_request
          expect(response.status).to eq 200
        end
      end

      context 'with invalid attributes' do
        let(:send_bad_request) { patch update_path, params: { id: question, question: attributes_for(:question, :invalid), access_token: access_token.token } }

        it 'does not update question' do
          expect { send_bad_request }.to_not change(question.reload, :title)
        end

        it 'does not create question' do
          send_bad_request
          expect(response.status).to eq 400
        end
      end
    end
  end
end