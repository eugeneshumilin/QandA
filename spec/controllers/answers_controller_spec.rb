require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }
  let(:another_user) { create(:user) }
  let!(:another_answer) { create(:answer, question: question, user: another_user) }

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

      it 'should render create template' do
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
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'should render to destroy view' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context "user tries to delete someone else's answer" do
      before { login(user) }

      it 'should not delete answer' do
        expect do
          expect { delete :destroy, params: { id: another_answer } }.to raise_exception(ActiveRecord::RecordNotFound)
        end.to_not change(Answer, :count)
      end
    end
  end

  describe 'PATCH #update' do
    context 'user tries to update his own answer' do
      before { login(user) }

      context 'with valid attributes' do

        it 'should change answer attributes' do
          patch :update, params: { id: answer, answer: { body: 'New body' } }, format: :js
          answer.reload
          expect(answer.body).to eq 'New body'
        end

        it 'should render update view' do
          patch :update, params: { id: answer, answer: { body: 'New body' } }, format: :js

          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        it 'should do not changes answer attributes' do
          expect do
            patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
          end.to_not change(answer.reload, :body)
        end

        it 'should render update view' do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js

          expect(response).to render_template :update
        end
      end
    end

    context "user tries to edit another user's answer" do
      before { login(user) }

      it 'should not update answer' do
        expect { patch :update, params: { id: another_answer, answer: { body: 'new body'} }, format: :js }.to raise_exception(ActiveRecord::RecordNotFound)
        another_answer.reload
        expect(another_answer.body).to_not eq 'new body'
      end
    end
  end

  describe 'PATCH #set_best' do
    let!(:another_question) { create(:question, user: another_user) }
    let!(:best_answer) { create(:answer, question: another_question, user: another_user) }
    before { login(user) }

    context 'author of question tries to set best answer' do

      it "should change 'is_best' answer's attribute as true" do
        patch :set_best, params: { id: answer }, format: :js
        answer.reload
        expect(answer).to be_is_best
      end
    end

    context "user tries to set best answer for someone else's question" do
      it "should not change 'is_best' answer's attribute" do
        expect { patch :set_best, params: { id: best_answer }, format: :js}.to raise_exception(ActiveRecord::RecordNotFound)
      end
    end
  end
end
