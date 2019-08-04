require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }

  describe 'DELETE #destroy' do
    before do
      attach_file_to(question)
      attach_file_to(answer)
    end

    context 'Author delete files' do
      before do
        login(user)
      end
      context 'question' do
        it "should delete question's file" do
          expect do
            delete :destroy, params: { id: question.files.first }, format: :js
          end.to change(ActiveStorage::Attachment, :count).by(-1)
        end

        it 'should re-render to question show view' do
          delete :destroy, params: { id: question.files.first }, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'answer' do
        it "should delete answer's file" do
          expect do
            delete :destroy, params: { id: answer.files.first }, format: :js
          end.to change(ActiveStorage::Attachment, :count).by(-1)
        end

        it 'should re-render to question show view' do
          delete :destroy, params: { id: answer.files.first }, format: :js
          expect(response).to render_template :destroy
        end
      end
    end

    context "user tries to delete someone else's question's and answer's file" do
      before do
        login(another_user)
      end
      it "should not delete question's file" do
        expect { delete :destroy, params: { id: question.files.first }, format: :js}.to_not change(ActiveStorage::Attachment, :count)
      end

      it "should not delete answers's file" do
        expect { delete :destroy, params: { id: answer.files.first }, format: :js}.to_not change(ActiveStorage::Attachment, :count)
      end
    end
  end
end