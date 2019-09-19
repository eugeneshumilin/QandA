require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end

  let(:access_token) { create(:access_token) }
  let(:user) { User.find(access_token.resource_owner_id) }
  let!(:question) { create(:question, user: user) }
  let!(:answers) { create_list(:answer, 3, question: question, user: user) }
  let(:answer) { answers.first }

  describe 'GET /api/v1/questions/:id/answers' do
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:answers_response) { json['answers'] }
      let(:answer_response) { answers_response.first }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(answers_response.size).to eq answers.size
      end

      it 'returns all public fields' do
        %w[id body user_id created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end
    end
  end

  describe 'GET /api/v1/answers/:id' do
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      include ControllerHelpers

      let!(:comments) { create_list(:comment, 3, commentable: answer, user: user) }
      let!(:links) { create_list(:link, 3, linkable: answer) }
      before { 3.times { attach_file_to(answer) } }

      let(:object_response) { json['answer'] }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'response success'

      it 'returns all public fields' do
        %w[id body user_id created_at updated_at].each do |attr|
          expect(object_response[attr]).to eq answer.send(attr).as_json
        end
      end

      it_behaves_like 'API comments'

      it_behaves_like 'API links'

      it_behaves_like 'API files' do
        let(:item) { answer }
      end
    end
  end

  describe 'POST /api/v1/questoin/:id/answers' do
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:headers) { nil }
      let(:method) { :post }
    end

    context 'authorized' do
      context 'with valid attributes' do
        let(:send_request) do
          post api_path,
               params: {
                   answer: attributes_for(:answer),
                   question_id: question,
                   access_token: access_token.token
               }
        end

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
        let(:send_bad_request) do
          post api_path,
               params: {
                   answer: attributes_for(:answer, :invalid),
                   question_id: question,
                   access_token: access_token.token
               }
        end

        it 'does not save question' do
          expect { send_bad_request }.to_not change(Answer, :count)
        end

        it 'does not create question' do
          send_bad_request
          expect(response.status).to eq 422
        end
      end
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:headers) { nil }
      let(:method) { :patch }
    end

    context 'authorized' do
      context 'with valid attributes' do
        let(:send_request) do
          patch api_path,
                params: {
                    id: answer,
                    answer: { body: 'new body'},
                    access_token: access_token.token
                }
        end

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
        let(:send_bad_request) do
          patch api_path,
                params: {
                    id: answer,
                    answer: attributes_for(:answer, :invalid),
                    access_token: access_token.token
                }
        end

        it 'does not update question' do
          body = answer.body
          send_bad_request
          answer.reload

          expect(answer.body).to eq body
        end

        it 'does not create question' do
          send_bad_request
          expect(response.status).to eq 422
        end
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:headers) { nil }
      let(:method) { :delete }
    end

    context 'authorized' do
      context 'with valid attributes' do
        let(:send_request) { delete api_path, params: { id: answer, access_token: access_token.token } }

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