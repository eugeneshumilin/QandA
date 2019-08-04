require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:another_question) { create(:question, user: another_user ) }
  let(:answer) { create(:answer, question: question, user: user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3, user: user) }

    before { get :index }

    it 'should populate an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'should render index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assignes the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'should render show view' do
      expect(response).to render_template :show
    end

    it 'assigns a new link for answer' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end
  end

  describe 'GET #new' do

    before { login(user) }

    before { get :new }

    it 'should render new view' do
      expect(response).to render_template :new
    end

    it 'assigns a new link to link' do
      expect(assigns(:question).links.first).to be_a_new(Link)
    end

    it 'assigns a new badge to badge' do
      expect(assigns(:question).badge).to be_a_new(Badge)
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'should save a new question in database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'should redirect to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with in-valid attributes' do

      it 'should not be saved in database' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end

      it 'should re-render new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end

    it 'should associated with user' do
      expect { post :create, params: { question: attributes_for(:question) }}.to change(user.questions, :count).by(1)
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }

    context 'user tries to delete own question' do

      it 'should delete question' do
        question
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'should redirect to index view' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context "user tries to delete someone else's question" do
      it 'should not delete question' do
        another_question
        expect {
          expect { delete :destroy, params: { id: another_question } }.to raise_exception(ActiveRecord::RecordNotFound)
        }.to_not change(Question, :count)
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    context 'user tries to update his own question' do

      context 'with valid attributes' do

        it 'should change question attributes' do
          patch :update, params: { id: question, question: { title: 'New title', body: 'New body' } }, format: :js
          question.reload
          expect(question.title).to eq 'New title'
          expect(question.body).to eq 'New body'
        end

        it 'should render update view' do
          patch :update, params: { id: question, question: { title: 'New title', body: 'New body' } }, format: :js

          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do

        it 'should do not changes question attributes' do
          expect do
            patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
          end.to_not change(question.reload, :title)
        end

        it 'should render update view' do
          patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js

          expect(response).to render_template :update
        end
      end
    end

    context "user tries to update another user's question" do

      it 'should not update question' do
        expect do
          patch :update, params: { id: another_question, question: attributes_for(:question) }, format: :js
        end.to raise_exception(ActiveRecord::RecordNotFound)
      end
    end
  end

  it_behaves_like 'liked'
end
