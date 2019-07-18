require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let!(:question) { create(:question, user: user) }

  describe 'DELETE #destroy' do
    before do
      login(user)
      attach_file_to(question)
    end

    context 'Author of question delete files' do
      it 'should delete file' do
        expect do
          delete :destroy, params: { id: question.files.first }, format: :js
        end.to change(ActiveStorage::Attachment, :count).by(-1)
      end

      it 'should re-render to question show view' do
        delete :destroy, params: { id: question.files.first }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context "user tries to delete someone else's question's file" do
      it "should not delete question's file" do
        login(another_user)
        expect { delete :destroy, params: { id: question.files.first }, format: :js}.to_not change(ActiveStorage::Attachment, :count)
      end
    end
  end
end