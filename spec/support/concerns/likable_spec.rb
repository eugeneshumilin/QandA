require 'rails_helper'

RSpec.shared_examples_for 'likable' do
  let(:model) { described_class }
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:likable) do
    if model.to_s == 'Answer'
      question = create(:question, user: user)
      create(model.to_s.underscore.to_sym, question: question, user: user)
    else
      create(model.to_s.underscore.to_sym, user: user)
    end
  end

  it '#vote_up' do
    likable.vote_up(another_user)

    expect(Like.last.rating).to eq 1
    expect(Like.last.user).to eq another_user
    expect(Like.last.likable).to eq likable
  end

  it '#vote_down' do
    likable.vote_down(another_user)
    expect(Like.last.rating).to eq -1
    expect(Like.last.user).to eq another_user
    expect(Like.last.likable).to eq likable
  end

  describe '#already_liked?' do
    before { likable.vote_up(another_user) }

    it 'resource already liked by user' do
      expect(likable).to be_already_liked(another_user)
    end

    it 'resource has no liked by user' do
      expect(likable).to_not be_already_liked(user)
    end
  end
end