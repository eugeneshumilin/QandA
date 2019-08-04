require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }
  let!(:question_link) { create(:link, linkable: question) }
  let!(:answer_link) { create(:link, linkable: answer) }

  describe 'DELETE #destroy' do
    before { login(user) }

    context 'Author' do
      it 'should delete question link' do
        expect do
          delete :destroy, params: { id: question_link }, format: :js
        end.to change(Link, :count).by(-1)
      end

      it 'should render destroy view' do
        delete :destroy, params: { id: question_link }, format: :js
        expect(response).to render_template :destroy
      end

      it 'should delete answer link' do
        expect do
          delete :destroy, params: { id: answer_link }, format: :js
        end.to change(Link, :count).by(-1)
      end

      it 'should render destroy view' do
        delete :destroy, params: { id: answer_link }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'user not an author' do
      before do
        login(another_user)
      end

      it 'delete the question link' do
        expect { delete :destroy, params: { id: question_link }, format: :js }.to_not change(Link, :count)
      end

      it 'delete the answer link' do
        expect { delete :destroy, params: { id: answer_link }, format: :js }.to_not change(Link, :count)
      end
    end
  end
end
