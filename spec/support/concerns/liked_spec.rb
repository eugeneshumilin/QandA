require 'rails_helper'

RSpec.shared_examples 'liked' do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:model) { described_class.controller_name.classify.constantize }


  describe 'POST #vote_up' do
    context 'user is not author of resource' do
      before { login(another_user) }

      let!(:user_likable) { liked(model, user) }

      it 'try to add new like' do
        expect { post :vote_up, params: { id: user_likable } }.to change(Like, :count)
      end
    end

    context 'user is author of resource' do
      before { login(user) }

      let!(:user_likable) { liked(model, user) }

      it 'can not add new like' do
        expect { post :vote_up, params: { id: user_likable } }.to_not change(Like, :count)
      end
    end
  end

  describe 'POST #vote_down' do
    context 'user is not author of resource' do
      before { login(another_user) }

      let!(:user_likable) { liked(model, user) }

      it 'try to add new dislike' do
        expect { post :vote_down, params: { id: user_likable } }.to change(Like, :count)
      end
    end

    context 'current user is author of resource' do
      before { login(user) }

      let!(:user_likable) { liked(model, user) }

      it 'can not add new dislike' do
        expect { post :vote_down, params: { id: user_likable } }.to_not change(Like, :count)
      end
    end
  end

  describe 'DELETE #cancel_vote' do
    context 'user can cancel his vote' do
      before { login(another_user) }

      let!(:user_likable) { liked(model, user) }

      it 'cancel vote' do
        post :vote_up, params: { id: user_likable }
        expect { delete :cancel_vote, params: { id: user_likable } }.to change(Like, :count).by(-1)
      end
    end

    context 'user can not cancel another vote' do
      let(:new_user) { create(:user) }
      let!(:new_like) { liked(model, new_user) }

      it "user can not cancel another user's vote" do
        expect { delete :cancel_vote, params: { id: new_like } }.to_not change(Like, :count)
      end
    end
  end
end