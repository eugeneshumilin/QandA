require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end

  let(:access_token) { create(:access_token) }
  let(:user) { User.find(access_token.resource_owner_id) }
  let!(:questions) { create_list(:question, 3, user: user) }
  let(:question) { questions.first }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end


    context 'authorized' do
      let(:question_response) { json['questions'].first }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq questions.size
      end

      it 'returns all public fields' do
        %w[id title body user_id created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      include ControllerHelpers

      let!(:comments) { create_list(:comment, 3, commentable: question, user: user) }
      let!(:links) { create_list(:link, 3, linkable: question) }
      before { 3.times { attach_file_to(question) } }

      let(:object_response) { json['question'] }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'response success'

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

  describe 'POST /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:headers) { nil }
      let(:method) { :post }
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
          expect(response.status).to eq 422
        end
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:headers) { nil }
      let(:method) { :patch }
    end

    context 'authorized' do
      context 'with valid attributes' do
        let(:send_request) do
          patch api_path,
                params: {
                    id: question,
                    question: { title: 'new title', body: 'new body'},
                    access_token: access_token.token
                }
        end

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
        let(:send_bad_request) do
          patch api_path,
                params: {
                    id: question,
                    question: attributes_for(:question, :invalid),
                    access_token: access_token.token
                }
        end

        it 'does not update question' do
          title = question.title
          body = question.body
          send_bad_request
          question.reload

          expect(question.title).to eq title
          expect(question.body).to eq body
        end

        it 'does not create question' do
          send_bad_request
          expect(response.status).to eq 422
        end
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:headers) { nil }
      let(:method) { :delete }
    end

    context 'authorized' do
      context 'with valid attributes' do
        let(:send_request) { delete api_path, params: { id: question, access_token: access_token.token } }

        it 'delete the question' do
          expect { send_request }.to change(Question, :count).by(-1)
        end
        it 'status success' do
          send_request
          expect(response.status).to eq 204
        end
      end
    end
  end
end