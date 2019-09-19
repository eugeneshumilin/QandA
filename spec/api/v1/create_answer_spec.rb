require 'rails_helper'

describe 'Answer API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end

  describe 'POST /api/v1/questoin/id/answers' do
    let(:api_path) { '/api/v1/questions/id/answers' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:question) { create(:question, user: User.find(access_token.resource_owner_id)) }
      let(:create_path) { "/api/v1/questions/#{question.id}/answers" }

      context 'with valid attributes' do
        let(:send_request) { post create_path, params: { answer: attributes_for(:answer), question_id: question, access_token: access_token.token } }

        it 'save new question' do
          expect { send_request }.to change(Answer, :count).by(1)
        end

        it 'status success' do
          send_request
          expect(response.status).to eq 200
        end

        it 'question has association with user' do
          send_request
          expect(Answer.last.user_id).to eq access_token.resource_owner_id
        end
      end

      context 'with invalid attributes' do
        let(:send_bad_request) { post create_path, params: { answer: attributes_for(:answer, :invalid), question_id: question, access_token: access_token.token } }

        it 'does not save question' do
          expect { send_bad_request }.to_not change(Answer, :count)
        end

        it 'does not create question' do
          send_bad_request
          expect(response.status).to eq 400
        end
      end
    end
  end
end