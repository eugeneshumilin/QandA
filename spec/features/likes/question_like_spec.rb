require 'rails_helper'

feature 'User can vote for a question', %q{
  In order to rate favorite question
  user as an authenticated user can vote
} do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Not an author', js: true do
    before { sign_in(another_user) }
    before { visit question_path(question) }

    scenario 'can vote up' do
      within ".Question-#{question.id}" do
        click_on '+'
        expect(page).to have_content '1'
      end
    end

    scenario 'can vote down' do
      within ".Question-#{question.id}" do
        click_on '-'
        expect(page).to have_content '-1'
      end
    end

    scenario 'can vote only once' do
      within ".Question-#{question.id}" do
        click_on '+'
        click_on '+'
        click_on '+'
        expect(page).to have_content '1'
      end
    end
  end

  describe 'Author' do
    scenario 'can not vote for his own question' do
      sign_in(user)
      visit question_path(question)

      expect(page).to_not have_css '.voting'
    end
  end
end