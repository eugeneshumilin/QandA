require 'rails_helper'

feature 'User can vote for a answer', %q{
  In order to rate favorite answer
  user as an authenticated user can vote
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user', js: true do
    before { sign_in(user) }
    before { visit question_path(question) }

    scenario 'can vote up' do
      within ".Answer-#{answer.id}" do
        click_on '+'
        expect(page).to have_content '1'
      end
    end

    scenario 'can vote down' do
      within ".Answer-#{answer.id}" do
        click_on '-'
        expect(page).to have_content '-1'
      end
    end
  end
end