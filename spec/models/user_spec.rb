require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions) }
  it { should have_many(:answers) }

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
end