require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'should saves a new answer in database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js }.to change(question.answers, :count).by(1)
      end

      it 'should render create view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template :create
      end
    end
    
    context 'with invalid attributes' do
      it 'should not be saved in database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js }.to_not change(Answer, :count)
      end

      it 'should re-render a question show view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js }
        expect(response).to render_template :create
      end
    end

    it 'should associated with user' do
      expect { post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js }.to change(user.answers, :count).by(1)
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }

    context 'user tries to delete own answer' do
      it 'should delete answer' do
        answer
        expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
      end

      it 'should redirect to show view' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(answer.question)
      end
    end

    context "user tries to delete someone else's answer" do
      before do
        @another_user = create(:user)
        @another_answer = create(:answer, question: question, user: @another_user)
      end

      it 'should not delete answer' do
        expect {
          expect { delete :destroy, params: { id: @another_answer } }.to raise_exception(ActiveRecord::RecordNotFound)
        }.to_not change(Answer, :count)
      end
    end
  end
end
