require 'rails_helper'

describe 'Question API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end

  describe 'POST /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      context 'with valid attributes' do
        let(:send_request) { post api_path, params: { question: attributes_for(:question), access_token: access_token.token } }

        it 'save new question' do
          expect { send_request }.to change(Question, :count).by(1)
        end

        it 'status success' do
          send_request
          expect(response.status).to eq 200
        end

        it 'question has association with user' do
          send_request
          expect(Question.last.user_id).to eq access_token.resource_owner_id
        end
      end

      context 'with invalid attributes' do
        let(:send_bad_request) { post api_path, params: { question: attributes_for(:question, :invalid), access_token: access_token.token } }

        it 'does not save question' do
          expect { send_bad_request }.to_not change(Question, :count)
        end

        it 'does not create question' do
          send_bad_request
          expect(response.status).to eq 400
        end
      end
    end
  end
end