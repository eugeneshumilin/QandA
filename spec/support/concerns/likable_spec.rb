require 'rails_helper'

RSpec.shared_examples_for 'likable' do
  let(:model) { described_class }
  let(:user) { create(:user) }
  let(:likable) do
    if model.to_s == 'Answer'
      question = create(:question, user: user)
      create(model.to_s.underscore.to_sym, question: question, user: user)
    else
      create(model.to_s.underscore.to_sym, user: user)
    end
  end

  it '#vote_up' do
    likable.vote_up(user)

    expect(Like.last.rating).to eq 1
    expect(Like.last.user).to eq user
    expect(Like.last.likable).to eq likable
  end

  it '#vote_down' do
    likable.vote_down(user)
    expect(Like.last.rating).to eq -1
    expect(Like.last.user).to eq user
    expect(Like.last.likable).to eq likable
  end
end