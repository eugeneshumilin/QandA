require 'rails_helper'

feature 'All users can view gist content' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, question: question, user: user) }
  given!(:gist_link_for_answer) { create(:link, :gist_link, linkable: answer) }
  given!(:gist_link_for_question) { create(:link, :gist_link, linkable: question) }
  given!(:gist_content) { 'Hello Thinknetica!' }

  describe 'Users', js: true do
    before { visit question_path(question) }

    scenario 'visible gist content in answer' do
      within ".link-#{gist_link_for_answer.id}" do
        expect(page).to have_content gist_content
      end
    end

    scenario 'visible gist content in question' do
      within ".link-#{gist_link_for_question.id}" do
        expect(page).to have_content gist_content
      end
    end
  end
end