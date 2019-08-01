require 'rails_helper'

feature 'User can vote for a question', %q{
  In order to rate favorite question
  user as an authenticated user can vote
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Authenticated user', js: true do
    before { sign_in(user) }
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
  end
end