require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  it { should allow_value("https://github.com").for(:url) }
  it { should_not allow_value('github').for(:url) }

  describe '#gist?' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:link) { create(:link, linkable: question) }
    let!(:gist_link) { create(:link, :gist_link, linkable: question) }

    it 'link url should match the gist' do
      expect(gist_link).to be_is_gist
    end

    it "link url don't should match the gist" do
      expect(link).to_not be_is_gist
    end
  end

  describe '#gist_content' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:link) { create(:link, :gist_link, linkable: question) }
    let!(:gist_content) { 'Hello Thinknetica!' }

    it 'should be returned a gist content' do
      expect(link.gist_content).to match gist_content
    end
  end
end
