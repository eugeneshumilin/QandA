require 'rails_helper'
require 'cancan/matchers'

describe Ability, type: :model do
  include ControllerHelpers

  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:other) { create(:user) }

    let(:question) { create(:question, user: user) }
    let(:other_question) { create(:question, user: other) }

    let(:answer) { create(:answer, question: question, user: user) }
    let(:other_answer) { create(:answer, question: other_question, user: other) }

    let(:comment) { create(:comment, commentable: question, user: user) }
    let(:other_comment) { create(:comment, commentable: question, user: other) }

    let(:link) { create(:link, linkable: question) }
    let(:other_link) { create(:link, linkable: other_question) }

    before do
      attach_file_to(question)
      attach_file_to(other_question)
    end

    it { should_not be_able_to :manage, :all }

    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :update, question }
    it { should be_able_to :update, answer }
    it { should be_able_to :update, comment}
    it { should_not be_able_to :update, other_question }
    it { should_not be_able_to :update, other_answer }
    it { should_not be_able_to :update, other_comment }

    it { should be_able_to :destroy, question }
    it { should be_able_to :destroy, answer}
    it { should be_able_to :destroy, link }
    it { should be_able_to :destroy, question.files.last}
    it { should_not be_able_to :destroy, other_question }
    it { should_not be_able_to :destroy, other_answer }
    it { should_not be_able_to :destroy, other_link }
    it { should_not be_able_to :destroy, other_question.files.last }

    it { should be_able_to [:vote_up, :vote_down], other_question }
    it { should be_able_to [:vote_up, :vote_down], other_answer }
    it { should_not be_able_to [:vote_up, :vote_down], question }
    it { should_not be_able_to [:vote_up, :vote_down], answer }

    it { should be_able_to :set_best, answer }
    it { should_not be_able_to :set_best, other_answer }

    it { should be_able_to :me, User }
  end
end