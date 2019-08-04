require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions) }
  it { should have_many(:answers) }
  it { should have_many :badges }

  describe "#author_of?(resource)" do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }
    let(:question) { create(:question, user: user) }

    it "user is the author" do
      expect(user).to be_author_of(question)
    end

    it "user is not an author" do
      expect(another_user).not_to be_author_of(question)
    end
  end

  describe '#get_reward!' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:badge) { create(:badge, question: question) }

    it 'user get the badge' do
      user.get_reward!(badge)

      expect(badge).to eq user.badges.last
    end
  end

  describe '#already_liked?' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }
    let(:question) { create(:question, user: user) }

    before { question.vote_up(another_user) }

    it 'user already liked the resource' do
      expect(another_user).to be_already_liked(question)
    end

    it 'user has not liked the resource' do
      expect(user).to_not be_already_liked(question)
    end
  end
end