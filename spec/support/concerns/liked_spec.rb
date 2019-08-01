require 'rails_helper'

RSpec.shared_examples 'liked' do
  let(:user) { create(:user) }
  let(:model) { described_class.controller_name.classify.constantize }

  before { login(user) }

  describe 'POST #vote_up' do
    context 'user is author of resource' do

      let!(:user_likable) { liked(model, user) }

      it 'try to add new like' do
        expect { post :vote_up, params: { id: user_likable } }.to change(Like, :count)
      end
    end
  end

  describe 'POST #vote_down' do
    context 'user is author of resource' do

      let!(:user_likable) { liked(model, user) }

      it 'try to add new dislike' do
        expect { post :vote_down, params: { id: user_likable } }.to change(Like, :count)
      end
    end
  end
end