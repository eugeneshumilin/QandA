require 'rails_helper'

RSpec.describe Answer, type: :model do
  it {should belong_to(:question)}
  it {should belong_to(:user)}

  it {should validate_presence_of(:body)}

  it { should have_db_index(:question_id) }

  it { should have_many(:links).dependent(:destroy) }

  it { should accept_nested_attributes_for :links }

  describe "#set_best" do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, user: user) }
    let!(:best_answer) { create(:answer, question: question, user: user, is_best: true) }

    it "the old best answer is no longer better" do
      answer.set_best
      best_answer.reload
      expect(best_answer).to_not be_is_best
    end

    it 'selected answer becomes best' do
      answer.set_best
      answer.reload
      expect(answer).to be_is_best
    end
  end

  it 'have many attached file' do
    expect(Answer.new.files).to be_an_instance_of ActiveStorage::Attached::Many
  end
end
